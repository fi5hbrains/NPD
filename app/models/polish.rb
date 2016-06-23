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

  def generate_preview layers, changed_layers = {}
    tmp_folder = self.tmp_folder
    reflection = self.gloss_tmp
    parts = "/assets/polish_parts/"
    
    c_duo = "#{parts}colour_duo.png"
    c_multi = "#{parts}colour_multi.png"
    c_cold = "#{parts}colour_cold.png"
    opacity_mask = "#{parts}opacity_#{(((self.opacity || 100) / 10).round * 10).to_s}.png"
    magnet = "#{tmp_folder}/magnet.png"
    holo = "#{parts}holo_default.png"
    mask = self.opacity_mask
        
    self.magnet ||= 'blank'
    old_coats_count = self.coats_count
    self.coats_count = (1 + 8 * (100 - (self.opacity || 100)) / 100).round
    
    noise_density = {'shimmer' => 0, 'flake' => 0, 'glitter' => 0}
    noise_size = {'shimmer' => 0, 'flake' => 0, 'glitter' => 0}
    sand_ordering = 0
    sand_size = 0
    sand_density = 0
    top_layer = 'base'
    sand_layer = layers.select{|l| l.layer_type == 'sand'}.first

    FileUtils.mkdir_p(path + tmp_folder)  
    
    layers.each_with_index do |layer, i|
      layer.c_base ||= '#F00'
      layer.highlight_colour ||= 'rgba(255,255,255,.2)'
      layer.shadow_colour ||= 'rgba(0,0,0,.4)'
      
      layer.ordering = i
      Delayed::Job.where(layer_ordering: layer.ordering).each(&:destroy)
      unless %w(base sand).include? layer.layer_type
        noise_density[layer.layer_type] += layer.particle_density
        noise_size[layer.layer_type] = [noise_size[layer.layer_type], layer.particle_size].max
      end
      if layer.layer_type == 'sand'
        sand_ordering = layer.ordering
        sand_size = [layer.particle_size, sand_size].max
        sand_density += layer.particle_density
      end
      top_layer = layer.layer_type

      if !layer.frozen? && (!changed_layers[layer.ordering.to_s].blank? && changed_layers[layer.ordering.to_s] != 0 || old_coats_count < self.coats_count)
        base = self.layer_tmp(layer.ordering)
        layer.opacity ||= 100
        
        if layer.layer_type == 'flake'
          flake_shadow_tmp = "#{tmp_folder}/layer_#{layer.ordering}_flake_shadow.mpc"
          mask = parts + 'flake_' + (layer.particle_size / 34 * 50).to_s + 
            '_' + ((layer.particle_density / 10.0).round * 10).to_s + '.png'
          Magick.convert mask + ' -page +0+1 -background none -flatten -blur 0x3 ', '\\( ' + path + mask + ' -negate \\) -compose Multiply -composite -brightness-contrast -20 ', flake_shadow_tmp
        end
        
        if layer.layer_type == 'glitter'
          particle_holo_base = "#{parts}holo_glitter.png"
          particle_holo = "#{tmp_folder}/holo_glitter.mpc"
          particle_hl_base = "#{parts}highlight_glitter.png"    
          particle_hl = "#{parts}highlight_glitter.mpc"
          shape = "#{parts}shape_#{layer.particle_type}.png"
          shape_tmp = "#{tmp_folder}/layer_#{layer.ordering}_shape.mpc"
          shape_shadow_tmp = "#{tmp_folder}/layer_#{layer.ordering}_shape_shadow.mpc"
          particle_scale = layer.particle_size ** 2 / 100 + 1
          holo_scale_k = ((particle_scale / 1.5 + 25) * 2).round
          
          Magick.convert particle_holo_base, "-scale #{holo_scale_k}%", particle_holo unless layer.holo_intensity == 0
          Magick.convert particle_hl_base, '', particle_hl unless FileTest.exist? particle_hl
          Magick.convert shape, "-scale #{particle_scale}%", shape_tmp
          Magick.convert shape, "-negate -blur 0x6 -scale #{particle_scale}% +level-colors '#444',Black ", shape_shadow_tmp
                    
          scale_offset = 50
          x_offset = 0 
          shadow_shift_x = 0
          shadow_shift_y = 2
          
          mask_stack      = []
          holo_stack      = []
          highlight_stack = []
          shadow_stack    = []
        end
        
        (layers.size > 1 ? self.coats_count : 1).times do |c| 
          if layer.layer_type == 'base' && sand_layer
            shadow       = "#{parts}shadow_sand_#{sand_layer.particle_size}_#{sand_layer.particle_density < 60 ? 'few' : 'many'}.png"
            highlight = "#{parts}highlight_sand_#{sand_layer.particle_size}_#{sand_layer.particle_density < 60 ? 'few' : 'many'}.png"
          else
            shadow = "#{parts}shadow_#{layer.layer_type}.png"
            highlight = "#{parts}highlight_#{layer.layer_type}.png"    
          end
          
          if layer.layer_type != 'base' || c == 0 
            if %w(shimmer flake).include? layer.layer_type
              shadow    += " -geometry +0-#{rand(28)}"
              highlight += " -geometry +0-#{rand(28)}"
            end
            if %w(shimmer flake).include? layer.layer_type
              mask = parts + layer.layer_type + '_' + (layer.particle_size / 34 * 50).to_s + 
              '_' + ((layer.particle_density / 10.0).round * 10).to_s + '.png -geometry +0-' + 
              rand(452).to_s 
            elsif layer.layer_type == 'glitter' 
              multiplier = (layer.particle_density * 20 / particle_scale).round + rand(2)
              mask             = "#{tmp_folder}/layer_#{layer.ordering.to_s}_mask.png"
              particles_hl     = "#{tmp_folder}/layer_#{layer.ordering.to_s}_highlight.png"
              holo             = "#{tmp_folder}/layer_#{layer.ordering.to_s}_holo.png"
              particles_shadow = "#{tmp_folder}/layer_#{layer.ordering.to_s}_particles_shadow.png" 
              pass = 0
              size = layer.particle_size  
              while multiplier >= 0 do
                mask_stack[c]      = ''
                shadow_stack[c]    = ''
                highlight_stack[c] = ''            
                holo_stack[c]      = ''   
              
                (multiplier > Defaults::STACK_LIMIT ? Defaults::STACK_LIMIT : multiplier).times do
                  rnd_x = rand(Defaults::CANVAS[0] - 2 * x_offset ) + x_offset - 96 * size / 100 + 10
                  scl_x = 100 * Math.sin(Math::PI*(rnd_x + 128 * size / 100 + scale_offset)/(Defaults::CANVAS[0] + 2 * scale_offset ))
                  rnd_y = rand(Defaults::CANVAS[1]) - 128 * size / 100 
                  rnd_r = rand(80) - 40   
                  
                  shape_transform = "-rotate #{rnd_r} -scale #{scl_x}%x100%"
                  shape_adjust = "#{path + shape_tmp} -background black #{shape_transform} -geometry +#{rnd_x}+#{rnd_y}"
                  mask_stack[c] += " \\( #{shape_adjust} -background white -alpha shape \\) -compose dissolve -define compose:args=#{layer.opacity} -composite "
                  shadow_stack[c] += " \\( #{path + shape_shadow_tmp} -background black #{shape_transform} -geometry +#{rnd_x + shadow_shift_x}+#{rnd_y + shadow_shift_y} \\) -compose Screen -composite \\( #{shape_adjust} -negate \\) -compose Multiply -composite "
                  highlight_stack[c] += " \\( \\( #{shape_adjust} -alpha copy \\) \\( #{path + particle_hl} -geometry -#{rnd_x}-#{rnd_y} \\) -compose In -composite \\) -alpha on -compose Over -composite "
                  holo_stack[c] += " \\( \\( #{shape_adjust} -alpha copy \\) \\( #{path + particle_holo} -geometry -#{rand((572 - holo_scale_k * 4) * holo_scale_k / 100 )}-#{rand((900 - holo_scale_k * 4) * holo_scale_k / 100)} \\) -compose In -composite \\) -alpha on -compose Over -composite "
                end    
                mask_pass = coat(mask,c)
                holo_pass = coat(holo,c)
                particles_shadow_pass = coat(particles_shadow,c)
                particles_hl_pass = coat(particles_hl,c)
                
                if pass == 0
                  mask_base = fill('black')
                  p_shadow_base = fill('black')
                  p_hl_base = fill('rgba(0,0,0,0)')
                  holo_base = fill('rgba(0,0,0,0)')
                else
                  mask_base = mask_pass
                  p_shadow_base = particles_shadow_pass
                  p_hl_base = particles_hl_pass
                  holo_base = holo_pass            
                end

                if c == 0
                  self.generate_glitter( mask_base, mask_stack[c], mask_pass, p_shadow_base, shadow_stack[c], particles_shadow_pass, p_hl_base, highlight_stack[c], particles_hl_pass, holo_base, holo_stack[c], holo_pass, layer.holo_intensity > 0)
                else
                  self.generate_glitter( mask_base, mask_stack[c], mask_pass, p_shadow_base, shadow_stack[c], particles_shadow_pass, p_hl_base, highlight_stack[c], particles_hl_pass, holo_base, holo_stack[c], holo_pass, layer.holo_intensity > 0)
                end
                multiplier -= Defaults::STACK_LIMIT
                pass += 1
              end
              mask = coat(mask,c)
              holo = coat(holo,c)
              particles_shadow = coat(particles_shadow,c)
              particles_hl = coat(particles_hl,c)
            end
            unless layer.layer_type == 'sand'

              convert_list = "\
#{"\\( #{path + c_duo} -background '#{layer.c_duo}' -alpha shape \\) -composite " unless layer.c_duo.blank?} \
#{"\\( #{path + c_multi} -background '#{layer.c_multi}' -alpha shape \\) -composite " unless layer.c_multi.blank?} \
#{"\\( #{path + c_cold} -background '#{layer.c_cold}' -alpha shape \\) -composite " unless layer.c_cold.blank?} \
\\( #{path + shadow} -background '#{layer.shadow_colour}' -alpha shape \\) -compose dissolve -define compose:args=#{get_alpha(layer.shadow_colour)} -composite \
#{" -alpha on -channel a -evaluate set #{layer.opacity}% " if layer.opacity < 100 && layer.layer_type != 'glitter'} \
#{" #{path + holo} -compose dissolve -define compose:args=#{layer.holo_intensity.to_s} -composite " if layer.holo_intensity > 0} \
#{" \\( #{path + highlight} -background '#{layer.highlight_colour}' -alpha shape \\) -compose dissolve -define compose:args=#{get_alpha(layer.highlight_colour)} -composite " unless layer.layer_type == 'glitter' } \
#{"\\( #{path + mask} -background white -alpha shape \\) -alpha on -compose DstIn -composite "} \
#{"\\( #{path + particles_shadow} -background black -alpha shape \\) -compose Over -composite " if layer.layer_type == 'glitter'} \
#{"\\( #{path + flake_shadow_tmp + mask.split('.png')[1]} -background black -alpha shape \\) -compose Over -composite " if layer.layer_type == 'flake'} \
#{"\\( #{path + particles_hl} -alpha off -background '#{layer.highlight_colour}' -alpha shape \\) -compose dissolve -define compose:args=#{get_alpha(layer.highlight_colour)} -composite " if layer.layer_type == 'glitter'} \
              -depth 8 "
              if c == 0
                Magick.convert(fill(layer.c_base), convert_list , coat(base, c))
                if layer.magnet_intensity > 0
                  magnet = self.magnet
                  Magick.convert base, '-compose dissolve -define compose:args=' + layer.magnet_intensity.to_s, self.magnet_url(base,magnet)
                end
              else
                Magick.delay( queue: (self.user_id || 'lalala'), layer_ordering: layer.ordering ).convert(fill(layer.c_base), convert_list , coat(base, c))
                if layer.magnet_intensity > 0
                  Defaults::MAGNETS.each do |magnet|
                    Magick.delay( queue: (self.user_id || 'lalala'), layer_ordering: layer.ordering ).convert base, '-compose dissolve -define compose:args=' + layer.magnet_intensity.to_s, self.magnet_url(base,magnet) unless magnet == self.magnet
                  end
                end
              end
            end
          end
        end
      end
      if self.crackle_type
        Magick.convert self.layer_tmp(layer.ordering), "\\( #{path + parts}mask_#{self.crackle_type}.png -negate -background black -alpha shape \\) -compose DstOut -composite ", self.crackled_url(self.layer_tmp(layer.ordering))
      end
    end
    
    ref_type = self.gloss_type
    noisiest = noise_density.sort_by{|k,v| v}[2]
    ref_density = 'default'
    if noisiest[1] > 10
      case noisiest[0]
      when 'shimmer'
        ref_size = (noise_size[noisiest[0]] <= 33 ? '0' : noise_size[noisiest[0]] <= 66 ? '25' : '50')
        ref_density = (noisiest[1] <= 33 ? 'few' : noisiest[1] <= 66 ? 'some' : noisiest[1] <= 95 ? 'many' : 'extra')
      when 'flake'
        if noisiest[1] >= 20 
          ref_size = 'foil'
          ref_density = (noisiest[1] <= 50 ? 'some' : noisiest[1] <= 95 ? 'many' : 'extra')
        end
      when 'glitter'
        ref_size = (noise_size[noisiest[0]] <= 20 ? '50' : noise_size[noisiest[0]] <= 50 ? '75' : '100')
        ref_density = (noisiest[1] <= 45 ? 'few' : noisiest[1] <= 90 ? 'some' : noisiest[1] <= 125 ? 'many' : 'extra')
      end
    end
    ref_source = "reflection_#{[ref_type, ref_size, ref_density].compact.join('_')}.png"
    
    if sand_ordering > 0
      sand_ref = "reflection_#{ref_type}_sand_#{sand_size}_#{sand_density < 60 ? 'few' : 'many'}.png" 
      if sand_ordering < (layers.size - 1)
        # todo generate upper layers mask > combine sand_ref & ref_source > generate reflection
      end

      Magick.convert parts + sand_ref, "+level-colors ,'#{self.gloss_colour}'", reflection  

    else
      Magick.convert parts + ref_source, "+level-colors ,'#{self.gloss_colour}'" + (self.crackle_type ? " #{path + parts}mask_#{self.crackle_type}.png -compose Multiply -composite" : ''), reflection   
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
  
  def generate_glitter( mask_base, mask_stack, mask_pass, p_shadow_base, shadow_stack, particles_shadow_pass, p_hl_base, highlight_stack, particles_hl_pass, holo_base, holo_stack, holo_pass, is_holo)
    Magick.convert mask_base, mask_stack, mask_pass            
    Magick.convert p_shadow_base, shadow_stack, particles_shadow_pass
    Magick.convert p_hl_base, highlight_stack, particles_hl_pass
    Magick.convert holo_base, holo_stack, holo_pass if is_holo
  end
  
  def self.find_brand_polishes brand, polish = nil, brands = nil
    if polish
      polish_ids = Synonym.
        where("name ilike ? AND word_type = 'Polish'", "%#{polish}%").
        pluck('word_id').compact.uniq
    else
      polish_ids = []
    end
    polishes = brand ? brand.polishes : brands ? Polish.where(brand_id: brands.pluck(:id)) : Polish.where(nil)
    return polishes.
      where( (polish_ids.empty? ? '' : "id IN (#{polish_ids.inspect.gsub('[', '').gsub(']','')}) OR ") + 
      "number ilike ? OR slug ilike ?", "%#{polish}%", "#{polish}%")
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
