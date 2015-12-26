class Polish < ActiveRecord::Base
  include Slugify, ColourMethods

  before_validation :name_or_number_to_slug
  before_save :set_colour
  
  validates :slug, uniqueness: {scope: :brand_slug, message: 'already exists for this brand', :case_sensitive => false }, :allow_blank => true
  validates :brand_slug, presence: true
  validates :bottle_id, presence: true
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
  def layer_tmp ordering, magnet = ''; "#{self.tmp_folder}/layer_#{ordering}.png" end

  def polish_folder  name_slug = self.slug, brand_slug = self.brand_slug;  "/assets/brands/#{brand_slug}/polish/#{name_slug}" end
  def coat_url coat_index = 0, name_slug = self.slug
    max_coats = ((self.layers_count == 0 ? self.layers.size : self.layers_count) == 1 ? 1 : self.coats_count)
    coat_index -= max_coats while coat_index >= max_coats
    self.polish_folder + '/' + name_slug + "_coat#{coat_index == 0 ? '' : "_x#{coat_index + 1}"}.png" 
  end
  def gloss_url; self.polish_folder + '/reflection.png' end
  def gloss_preview_url; self.tmp_folder + '/reflection_preview.jpg' end
  def preview_url; self.polish_folder + '/preview.png' end
  def bottle_url option = nil, from_magick = false, name_slug = self.slug
    if from_magick
      self.polish_folder + '/' + name_slug + '_bottle' + (option ? '_' + option : '' )  + '.png' 
    else
      if self.draft
        'draft.png'
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
  
  def layers_to_hash
    mergee = {}
    mergee['layers_attributes'] = {}
    self.layers.each{|l| mergee['layers_attributes'][l.ordering] = l.attributes.except!('id','created_at','updated_at')}
    return mergee
  end
  
  def set_colour
    unless self.draft
      base = self.layers.detect{|l| l.layer_type == 'base'}
      hsl = colour_to_hsl((base.c_multi if !base.c_multi.blank?) || (base.c_duo if !base.c_duo.blank?) || base.c_base)
      hsl2 = colour_to_hsl(base.c_base) if (base.c_multi if !base.c_multi.blank?) || (base.c_duo if !base.c_duo.blank?)
      self.h = hsl[0]; self.s = hsl[1]; self.l = hsl[2]
      if hsl2
        self.h2 = hsl2[0]; self.s2 = hsl2[1]; self.l2 = hsl2[2]
      end
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
    
  private  
  
  def name_or_number?
    if %w(name number).all?{|attr| self[attr].blank?}
      errors.add(:name, "or a product number must be present")
    end
  end  

end
