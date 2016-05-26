# encoding: utf-8
class Polish < ActiveRecord::Base
  include Slugify, ColourMethods, MagickMethods

  before_validation :name_or_number_to_slug
  before_save :set_colour
  
  validates :slug, uniqueness: {scope: :brand_slug, message: 'already exists for this brand', :case_sensitive => false }, :allow_blank => true
  validates :brand_slug, presence: true
  # validates :bottle_id, presence: true
  validate :name_or_number?
  
  belongs_to :collection
  belongs_to :brand, counter_cache: true
  belongs_to :added_by, class_name: 'User', foreign_key: 'user_id'
  has_many :layers, class_name: 'PolishLayer'
  accepts_nested_attributes_for :layers, allow_destroy: true
  
  has_many :versions, class_name: 'PolishVersion'
  has_many :box_items, dependent: :destroy
  has_many :boxes, through: :box_items
  has_many :synonyms, as: :word, dependent: :destroy
  has_many :usages, dependent: :destroy
  has_many :votes, as: :votable, class_name: 'UserVote', dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :entries, through: :usages
  has_many :comments, as: :commentable
  
  mount_uploader :reference, ReferenceUploader  
  
  def collection
    Collection.find(self.collection_id).try(:name) if self.collection_id 
  end
  def collection=(name)
    self.collection_id = Collection.where(brand_id: self.brand_id, name: name).first_or_create!.id if (name && name.present?)
  end
  def synonym_list; self.synonyms.map(&:name).try(:join, '; ')  end
  def synonym_list=(names)
    self.synonyms = names.split(';').map{|n| Synonym.where(word_type: 'Polish', word_id: self.id, name: n.strip).first_or_create!} 
  end 
  
  def to_param; slug end
  
  def name_or_number; self.name || self.number end
  def name_and_number; self.number.to_s + (' – ' unless self.number.blank? || self.name.blank?).to_s + self.name.to_s end
  def brand_number_or_name; self.name.blank? ? self.brand_name + self.number : self.name end
  
  def name_or_number_to_slug
    self.prefix.squish! if self.prefix
    self.name.squish! if self.name
    self.number.squish! if self.number
    if self.name || self.number
      self.slug = slugify((self.prefix.blank? ? '' : self.prefix + '-') + (self.name || self.number))
    end
  end  
  
  def tmp_folder; "/assets/polish_tmp/#{self.user_id || 0}" end
  def opacity_mask
    "/assets/polish_parts/opacity_#{self.opacity.blank? ? '90' : ((self.opacity / 10.0).round * 10)}.png" 
  end
  def gloss_tmp; self.tmp_folder + '/reflection.png' end
  def layer_tmp ordering; "#{self.tmp_folder}/layer_#{ordering}.png" end
  def crackled_url source; source.sub('.png', '_crackled.png') end
  def magnet_url source, magnet; source.sub('.png', "_#{magnet}.png") end

  def polish_folder  name_slug = self.slug, brand_slug = self.brand_slug;  "/assets/brands/#{brand_slug}/polish/#{name_slug}" end
  def coat_url coat_index = 0, name_slug = self.slug
    max_coats = ((self.layers_count == 0 ? self.layers.size : self.layers_count) == 1 ? 1 : self.coats_count)
    coat_index -= max_coats while coat_index >= max_coats
    self.polish_folder + '/' + name_slug + "_coat#{coat_index == 0 ? '' : "_x#{coat_index + 1}"}.png" 
  end
  def notify
    self.versions.pluck(:user_id).uniq.each do |u_id|
      unless self.user_id == u_id
        Event.new(user_id: u_id, event_type: 'polish', author: User.find(self.user_id).name, eventable_type: 'Polish', eventable_id: self.id).save
      end
    end
  end
  def gloss_url; self.polish_folder + '/reflection.png' end
  def gloss_preview_url; self.tmp_folder + '/reflection_preview.jpg' end
  def preview_url version = ''; self.polish_folder + "/preview#{version}.png" end
  def bottle_url option = nil, from_magick = false, name_slug = self.slug
    if from_magick
      self.polish_folder + '/' + name_slug + '_bottle' + (option ? '_' + option : '' )  + '.png' 
    else
      if self.draft
        '/assets/draft.png'
      elsif self.bottling_status
        self.polish_folder + '/' + name_slug + '_bottle' + (option ? '_' + option : '' )  + '.png' 
      else
        'spin.svg'
      end
    end
  end
  
  def calculate_rating
    self.rating = self.votes.to_a.sum{|v| v.rating}.to_f / self.votes_count
    self.save
  end
  
  def set_colour
    unless self.draft
      base = self.layers.detect{|l| l.layer_type == 'base'}
      hsl = colour_to_hsl((base.c_multi if !base.c_multi.blank?) || (base.c_duo if !base.c_duo.blank?) || base.c_base)
      hsl2 = colour_to_hsl(base.c_base) if (base.c_multi if !base.c_multi.blank?) || (base.c_duo if !base.c_duo.blank?)
      self.h = hsl[0]
      self.s = hsl[1]
      self.l = hsl[2]
      self.lightness_group = (self.l/50.0).round
      if hsl2
        self.h2 = hsl2[0]; self.s2 = hsl2[1]; self.l2 = hsl2[2]
      end
    end
  end
  
  def to_yaml
    mergee = {}
    mergee['layers_attributes'] = {}
    self.layers.each do |l|
      mergee['layers_attributes'][l.ordering] = l.attributes.except('id','polish_id','created_at','updated_at').reject{|k,v| v.blank?}
    end
    attributes = self.attributes.except('id', 'name', 'bottle_id', 'slug', 'collection_id', 'brand_id', 'brand_name', 'brand_slug', 'coats_count', 'layers_count','draft', 'bottling_status', 'crackle_type', 'h', 's', 'l', 'h2', 's2', 's2', 'magnet', 'reference', 'user_id', 'created_at', 'updated_at', 'lock', 'votes_count', 'usages_count', 'comments_count', 'rating').reject{|k,v| v.blank?}
    (mergee['layers_attributes'].size > 0 ? attributes.merge( mergee) : attributes).to_yaml
  end 

  def save_version action
    self.save_version_images
    tmp_hash = self.to_yaml
    unless self.versions.first.try(:polish) == tmp_hash
      version = self.versions.new
      version.polish = tmp_hash
      user = self.added_by
      version.version = self.versions.count
      version.event = action
      version.user_id = self.user_id
      version.user_name = user.name
      version.user_avatar_url = user.avatar_url('thumb')
      version.save
    end
  end
  
  def save_version_images index_old='', index_new=nil
    index_new ||= self.versions.count - 1
    if self.versions.count > 0
      copy ||= self
      FileUtils::cp path + self.preview_url(index_old), path + copy.preview_url(index_new) if File.exists? path + self.preview_url(index_old)
    end
  end
  
  def get_colour
    c = (self.h2 ? [self.h2, self.s2, self.l2] : [self.h, self.s, self.l])
    "hsl(#{c.join(',')})"
  end
  
  def self.in_brands(brands); where("brand_id IN (?)", brands.pluck(:id)) end 
  def self.by_hue(hue); order( "ABS(h - #{hue}) ASC") end
  def self.coloured colour = nil, spread = nil
    hslh = new.colour_to_hsl_range(colour,spread)
    if hslh
      where(
        h: [(hslh[:h] || (0..360)), hslh[:h2]], 
        s: (hslh[:s] || (0..100)), 
        l: (hslh[:l] || (0..100)),
        opacity: (hslh[:o] || (0..100)))
    else
      where(nil)
    end
  end

  def flatten_layers layers
    FileUtils.mkdir_p(path + self.polish_folder) unless File.directory?(path + self.polish_folder)
    File.rename path + self.gloss_tmp, path + self.gloss_url
    Magick.convert self.gloss_url, '-resize ' + Defaults::BOTTLE.map{|c| c * 2}.join('x') + ' -gravity center', self.gloss_preview_url
    (layers.size > 1 ? self.coats_count : 1).times do |c|
      stack = ''
      layers.each do |layer|
        stack += path + coat("#{self.tmp_folder}/layer_#{layer.ordering}.png", c) + ' -composite ' unless %w(base sand).include?(layer.layer_type)
      end
      if self.crackle_type
        stack += " \\( +clone \\( #{path}/assets/polish_parts/mask_#{self.crackle_type}.png -negate -background black -alpha shape \\) -compose DstOut -composite  -write #{path + self.crackled_url(self.coat_url(c))} +delete \\) "
      end
      Magick.convert "#{self.tmp_folder}/layer_0.png", stack + ' -depth 8', self.coat_url(c)
      
    end
    generate_bottle
  end

  def generate_bottle redress = false
    bottle = Bottle.find_by_id(self.bottle_id)
    return true unless bottle   
    preview_mask = path + '/assets/polish_parts/preview_mask.png'
    blur = bottle.blur > 5 ? " -blur 0x#{bottle.blur/10}" : ''
    # usm = '-unsharp 0x.4'
    # usm = '-unsharp 0x3+1.5+0.0196'
    usm = '-unsharp 0.25x0.25+8+0.065'
    
    stack = path + self.coat_url   
    (self.coats_count - 1).times{|c| stack += " #{path + self.coat_url( c + 1)} -composite "}  
    unless redress
      stack += " \\( +clone #{"\\( #{path}/assets/polish_parts/mask_#{self.crackle_type}.png -negate -background black -alpha shape \\) -compose DstOut -composite" if self.crackle_type} -resize #{Defaults::BOTTLE.map{|c| c*2}.join('x')} -gravity South #{usm} #{path + self.gloss_preview_url} -channel RGB -compose Screen -composite \\( #{preview_mask} -background white -alpha shape \\) -alpha on -compose DstIn -composite -write #{path + self.preview_url} +delete \\) "
    end
    stack = " \\( #{stack} \\) -resize 150x100\! -set option:distort:viewport #{Defaults::BOTTLE.map{|c| c*2}.join('x')}-58-65 -virtual-pixel Mirror -filter point -distort SRT 0 +repage #{usm} #{blur} "
    stack += " #{path + bottle.shadow_url} -channel RGB -compose Multiply -composite "
    stack += " #{path + bottle.highlight_url} -channel RGB -compose Screen -composite "
    stack = "\\( #{stack} \\( #{path + bottle.mask_url} -alpha copy \\) -compose Dstin -composite \\) -compose Over -composite "
    stack += " \\( +clone -resize #{Defaults::BOTTLE.map{|c| c/2}.join('x')}^ -gravity center -extent #{Defaults::BOTTLE.map{|c| c/2}.join('x')} -write #{path + self.bottle_url('thumb', true)} +delete \\) "
    stack += " \\( +clone -resize #{Defaults::BOTTLE.join('x')}^ -gravity center -extent #{Defaults::BOTTLE.join('x')} -write #{path + self.bottle_url('big', true)} +delete \\) "
    Magick.convert bottle.base_url, stack, self.bottle_url(nil, true) 
    Magick.pngquant [self.bottle_url('big', true), self.bottle_url('thumb', true), self.bottle_url(nil, true), self.preview_url ]
    self.update_attributes bottling_status: true
  end
  
  private  
  
  def path
    Rails.root.join('public').to_s
  end
  
  def name_or_number?
    if %w(name number).all?{|attr| self[attr].blank?}
      errors.add(:name, "or a product number must be present")
    end
  end  

end
