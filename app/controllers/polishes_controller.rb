class PolishesController < ApplicationController
  include Slugify, ColourMethods, MagickMethods

  def index
    set_brand
    search
    @polishes = @polishes.order(cookies[:polish_sort]).page(params[:page]).per(48)
  end

  def show
    set_polish
    set_user_votes
    set_collections
    @synonyms = @polish.synonyms.to_a
    @synonyms.shift
    @comments = @polish.comments
    set_users @comments
    if !in_lab? && !@polish.draft
      find_related @polish
      render 'catalogue_show'
    else
      @polishes = @brand.polishes.order('created_at desc').page(params[:page])
    end
  end
  
  def new
    set_brand
    set_bottles
    @polish = Polish.new
    @polish.bottle_id = params[:bottle] || Brand.find_by_slug('default').bottles.first.id
    @polish.layers.new(layer_type: 'base')
    @polishes = @brand.polishes.order('created_at desc').page(params[:page]).per(12)
  end

  def edit
    set_polish
    set_bottles
    @polishes = @brand.polishes.order('created_at desc').where("id != #{@polish.id}").page(params[:page]).per(12)
    @layers = @polish.layers
    generate_preview
  end
  
  def redress
    set_polish
    set_bottles
  end
  
  def collect
    unless params[:box].blank?
      collection = (@box = current_user.boxes.find_or_initialize_by slug: slugify(params[:box]) ).box_items
      if @box.new_record? 
        @box.name = params[:box]
        @box.save
        @box_is_new = true
      end
      if (item = collection.detect{|item| item.polish_id == params[:polish_id].to_i})
        item.destroy
        @is_in = false
      else
        (@item = BoxItem.new box_id: @box.id, polish_id: params[:polish_id]).save
        @is_in = true
      end
      if @is_in 
        @polishes = Polish.where('id NOT IN (?)', collection.map( &:polish_id)).page(params[:page_b]).per(12)
        @next_item = @polishes.last if @polishes.count >= 12
      else
        @polishes = @box.polishes.page(params[:page_b])
        @next_item = @polishes.last if @polishes.count >= 24
      end 
      
    end
  end

  def create
    set_brand
    set_bottles
    @polish = @brand.polishes.new(polish_params)
    @polish.brand_name = @brand.name
    @polish.brand_slug = @brand.slug
    @polish.user_id = current_user.id
    set_name
    all_layers_bottom_up
    
    if params[:preview]
      generate_preview params[:changes]
      respond_to do |format|
        format.html {render :new}
        format.js {render 'preview'}
      end
    elsif @polish.valid?
      @polish.update_attributes bottling_status: false
      generate_preview params[:changes]
      @polish.save
      flatten_layers
      redirect_to @brand, notice: 'Polish was successfully created.' 
    else
      @polishes = @brand.polishes.order('created_at desc').page(params[:page]).per(12)
      render :new
    end
  end

  def update
    set_polish
    set_bottles
    old_bottle_id = @polish.bottle_id
    old_slug = @polish.slug
    @polish.assign_attributes polish_params
    set_name
    @polish.user_id = current_user.id
    all_layers_bottom_up
    if params[:preview]
      generate_preview params[:changes]
      respond_to do |format|
        format.html {render :edit}
        format.js {render 'preview'}
      end
    elsif @polish.valid?
      @polish.update_attributes bottling_status: false, draft: false
      if params[:redress]
        @polish.save
        rename_polish_files old_slug if old_slug != @polish.slug
        generate_bottle if old_bottle_id != @polish.bottle_id
        redirect_to @brand, notice: 'Polish was successfully updated.' 
      else
        @polish.layers.each{|l| l.destroy unless l.new_record?}
        generate_preview params[:changes]
        @polish.save
        flatten_layers
        redirect_to @brand, notice: 'Polish was successfully updated.' 
      end
    else
      render (params[:redress] ? :redress : :edit)
    end
  end
  
  def clone
    set_polish
    @copy = @polish.dup
    @copy.layers_count = 0
    case (copies = @brand.polishes.where('slug ~ ?', "#{@polish.slug}_copy\((\d*|)\)$")).size
    when 0
      @copy.name = @copy.name_or_number + '_copy'
    when 1
      @copy.name = @copy.name_or_number + '_copy(2)'
    else
      last = copies.
        sort{|a,b| a.slug.split('_copy(').last.to_i <=> b.slug.split('_copy(').last.to_i}.
        last.slug.split('_copy(').last.to_i
      @copy.name = @copy.name_or_number + "_copy#{(last + 1)}"
    end
    @copy.assign_attributes @polish.layers_to_hash
    @copy.save
    rename_polish_files @polish.slug, @copy
    respond_to do |format|
      format.html { redirect_to @brand, notice: 'Polish was successfully cloned.' }
      format.js
    end
  end
  
  def lock
    @polish = Polish.find(params[:polish_id])
    @polish.lock = !@polish.lock
    @polish.save
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  def destroy
    set_polish
    @id = @polish.id
    @polish.destroy
    respond_to do |format|
      format.html { redirect_to @brand, notice: 'Polish was successfully destroyed.' }
      format.js
    end
  end
  
  def get_bottling_status
    @polish = Polish.find(params[:id])
    head 204, content_type: "text/html" unless @polish.bottling_status
  end
  
  def find_related polish = nil, spread = nil
    cookies[:spread] = params[:spread].to_i if params[:spread]
    @polish = polish || Polish.find(params[:polish_id]) if params[:polish_id]
    spread = spread || cookies[:spread] || 20
    @related = Polish.
      coloured( [@polish.h, @polish.s, @polish.l, @polish.opacity], spread)
  end
  
  def reorder
    (params[:polish] || params[:brand] || params[:colour]) ? search : @polishes = Polish.all
    @polishes = @polishes.order(cookies[:polish_sort]).page(params[:page]).per(48)
  end
  
  def note
    note = Note.find_or_initialize_by(user_id: current_user.id, polish_id: params[:polish_id])
    if params[:body].try(:strip).blank?
      note.destroy
    else
      note.body = params[:body]
      note.save
    end
  end

  private

  def set_polish
    set_brand
    @polish = @brand.polishes.find_by_slug(slugify params[:polish_id])
  end
  def set_name
    @polish.name = params[:polish][:synonym_list].split(';')[0].try(:strip)
  end
  def polish_params
    params.require(:polish).permit(
      :name, :synonym_list, :number, :release_year, :collection, :bottle_id, :gloss_type, 
      :gloss_colour, :opacity, :reference, :remote_reference_url, :remove_reference, :reference_cache,
      {layers_attributes: [ 
        :layer_type, :ordering, :c_base, :c_duo, :c_multi, :c_cold, 
        :highlight_colour, :shadow_colour, :opacity, :particle_type, :particle_size, 
        :particle_density, :holo_intensity, :thickness, :magnet_intensity, :_destroy 
      ]})
  end
  
  def rename_polish_files old_slug, polish = nil
    copy = polish.present?
    polish ||= @polish
    if copy
      FileUtils.copy_entry path + polish.polish_folder(old_slug), path + polish.polish_folder 
    else
      FileUtils.mv path + polish.polish_folder(old_slug), path + polish.polish_folder 
    end
    (polish.layers.count > 1 ? polish.coats_count : 1).
      times{|c| FileUtils.mv( path + polish.coat_url(c, old_slug), path + polish.coat_url(c))}
    [nil, 'thumb', 'big'].each do |option| 
      FileUtils.mv( path + polish.bottle_url(option, true, old_slug), path + polish.bottle_url(option, true) ) end
  end
  
  def generate_preview changed_layers = {}
    tmp_folder = @polish.tmp_folder
    reflection = @polish.gloss_tmp
    parts = "/assets/polish_parts/"
    
    c_duo = "#{parts}colour_duo.png"
    c_multi = "#{parts}colour_multi.png"
    c_cold = "#{parts}colour_cold.png"
    opacity_mask = "#{parts}opacity_#{((@polish.opacity / 10).round * 10).to_s}.png"
    magnet = "#{tmp_folder}/magnet.png"
    holo = "#{parts}holo_default.png"
    mask = @polish.opacity_mask
        
    @polish.magnet ||= 'blank'
    old_coats_count = @polish.coats_count
    @polish.coats_count = (1 + 6 * (100 - @polish.opacity) / 100).round
    noise_size = (@layers.size > 1 ? 10 : 0)
    noise_density = 0
    small_noise_density = 0
    top_layer = 'base'

    FileUtils.mkdir_p(path + tmp_folder)  
    
    @layers.each do |layer|
      noise_size = layer.particle_size if %w(glitter flake).include?(layer.layer_type) && layer.particle_size  > noise_size
      noise_density += layer.particle_density if %w(glitter flake).include?(layer.layer_type)
      small_noise_density += layer.particle_density if layer.layer_type == 'shimmer' && layer.particle_size > 50
      top_layer = layer.layer_type
      
      if !layer.frozen? && (changed_layers[layer.ordering.to_s].blank? || changed_layers[layer.ordering.to_s] != 0 || old_coats_count < @polish.coats_count)
        base = "#{tmp_folder}/layer_#{layer.ordering}.png"    
        layer.opacity ||= 100

        if layer.layer_type == 'glitter'
          particle_holo_base = "#{parts}holo_glitter.png"
          particle_holo = "#{parts}holo_glitter.mpc"
          particle_hl_base = "#{parts}highlight_glitter.png"    
          particle_hl = "#{parts}highlight_glitter.mpc"
          shape = "#{parts}shape_#{layer.particle_type}.png"
          shape_tmp = "#{tmp_folder}/layer_#{layer.ordering}_shape.mpc"
          shape_shadow_tmp = "#{tmp_folder}/layer_#{layer.ordering}_shape_shadow.mpc"
          particle_scale = layer.particle_size ** 2 / 100 + 1
          
          Magick.convert particle_holo_base, '', particle_holo unless layer.holo_intensity == 0 || FileTest.exist?( particle_holo)
          Magick.convert particle_hl_base, '', particle_hl unless FileTest.exist? particle_hl
          Magick.convert shape, "-scale #{particle_scale}%", shape_tmp
          Magick.convert shape, "-negate -blur 0x6 -scale #{particle_scale}% +level-colors '#444',Black ", shape_shadow_tmp
          
          multiplyer = (layer.particle_density * 5.0 / particle_scale).round + rand(2)
          scale_offset = 50
          x_offset = 15 
          shadow_shift_x = 0
          shadow_shift_y = 2
          
          mask_stack      = []
          holo_stack      = []
          highlight_stack = []
          shadow_stack    = []
        end
        
        (@layers.size > 1 ? @polish.coats_count : 1).times do |c| 
          shadow = "#{parts}shadow_#{layer.layer_type}.png"
          highlight = "#{parts}highlight_#{layer.layer_type}.png"    
          
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
              mask             = "#{tmp_folder}/layer_#{layer.ordering.to_s}_mask.png"
              particles_hl     = "#{tmp_folder}/layer_#{layer.ordering.to_s}_highlight.png"
              holo             = "#{tmp_folder}/layer_#{layer.ordering.to_s}_holo.png"
              particles_shadow = "#{tmp_folder}/layer_#{layer.ordering.to_s}_particles_shadow.png"

              mask_stack[c]      = ''
              shadow_stack[c]    = ''
              highlight_stack[c] = ''            
              holo_stack[c]      = ''            
              
              multiplyer.to_i.times do
                rnd_x = rand(Defaults::CANVAS[0] - 2 * x_offset ) + x_offset - 96 * layer.particle_size / 100 
                scl_x = 100 * Math.sin(Math::PI*(rnd_x + 128 * layer.particle_size / 100 + scale_offset)/(Defaults::CANVAS[0] + 2 * scale_offset ))
                rnd_y = rand(Defaults::CANVAS[1]) - 128 * layer.particle_size / 100 
                rnd_r = rand(80) - 40   
                
                shape_transform = "-rotate #{rnd_r} -scale #{scl_x}%x100%"
                shape_adjust = "#{path + shape_tmp} -background black #{shape_transform} -geometry +#{rnd_x}+#{rnd_y}"
                mask_stack[c] += " \\( #{shape_adjust} -background white -alpha shape \\) -compose dissolve -define compose:args=#{layer.opacity} -composite "
                shadow_stack[c] += " \\( #{path + shape_shadow_tmp} -background black #{shape_transform} -geometry +#{rnd_x + shadow_shift_x}+#{rnd_y + shadow_shift_y} \\) -compose Screen -composite \\( #{shape_adjust} -negate \\) -compose Multiply -composite "
                highlight_stack[c] += " \\( \\( #{shape_adjust} -alpha copy \\) \\( #{path + particle_hl} -geometry -#{rnd_x}-#{rnd_y} \\) -compose In -composite \\) -alpha on -compose Over -composite "
                holo_stack[c] += " \\( \\( #{shape_adjust} -alpha copy \\) \\( #{path + particle_holo} -geometry -#{rand(572 - 256 * layer.particle_size / 100)}-#{rand(900 - 256 * layer.particle_size / 100)} \\) -compose In -composite \\) -alpha on -compose Over -composite "
              end    
              mask = coat(mask,c)
              holo = coat(holo,c)
              particles_shadow = coat(particles_shadow,c)
              particles_hl = coat(particles_hl,c)

              if c == 0
                Magick.convert fill('black'), mask_stack[c], mask                
                Magick.convert fill('black'), shadow_stack[c], particles_shadow
                Magick.convert fill('rgba(0,0,0,0)'), highlight_stack[c], particles_hl
                Magick.convert fill('rgba(0,0,0,0)'), holo_stack[c], holo  if layer.holo_intensity > 0
              else
                Magick.delay( queue: current_user.id ).convert fill('black'), mask_stack[c], mask                
                Magick.delay( queue: current_user.id ).convert fill('black'), shadow_stack[c], particles_shadow
                Magick.delay( queue: current_user.id ).convert fill('rgba(0,0,0,0)'), highlight_stack[c], particles_hl
                Magick.delay( queue: current_user.id ).convert fill('rgba(0,0,0,0)'), holo_stack[c], holo  if layer.holo_intensity > 0
              end
            end
            
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
#{"\\( #{path + particles_hl} -alpha off -background '#{layer.highlight_colour}' -alpha shape \\) -compose dissolve -define compose:args=#{get_alpha(layer.highlight_colour)} -composite " if layer.layer_type == 'glitter'} \
            "
            if c == 0
              Magick.convert(fill(layer.c_base), convert_list , coat(base, c))
              if layer.magnet_intensity > 0
                magnet = @polish.magnet
                Magick.convert base, '-compose dissolve -define compose:args=' + layer.magnet_intensity.to_s, base.gsub('.png', '_' + magnet + '.png')
              end
            else
              Magick.delay( queue: current_user.id ).convert(fill(layer.c_base), convert_list , coat(base, c))
              if layer.magnet_intensity > 0
                Defaults::MAGNETS.each do |magnet|
                  Magick.delay( queue: current_user.id ).convert base, '-compose dissolve -define compose:args=' + layer.magnet_intensity.to_s, base.gsub('.png', '_' + magnet + '.png') unless magnet == @polish.magnet
                end
              end
            end
          end
        end
      end
    end
  
    noise_density = small_noise_density if noise_density == 0 && small_noise_density > 0
    ref_type = @polish.gloss_type
    ref_density = (noise_density <= 33 ? nil : noise_density <= 66 ? 'some' : noise_density <= 66 ? 'many' : 'extra')
    ref_size = ((noise_size == 0 || !ref_density) ? 'default' : top_layer == 'flake' ? 'foil' : noise_size <= 10 ? 'tiny' : noise_size <= 50 ? 'medium' : 'big' )
    ref_source = "reflection_#{[ref_type, ref_size, ref_density].compact.join('_')}.png"
    Magick.convert parts + ref_source, "+level-colors ,'#{@polish.gloss_colour}'", reflection   
  end

  def flatten_layers
    FileUtils.mkdir_p(path + @polish.polish_folder) unless File.directory?(path + @polish.polish_folder)
    File.rename path + @polish.gloss_tmp, path + @polish.gloss_url
    Magick.convert @polish.gloss_url, '-resize 128x139 -gravity center', @polish.gloss_preview_url
    (@layers.size > 1 ? @polish.coats_count : 1).times do |c|
      stack = ''
      @layers.each do |layer|
        stack += path + coat("#{@polish.tmp_folder}/layer_#{layer.ordering}.png", c) + ' -composite ' unless layer.layer_type == 'base'
      end
      Magick.delay( queue: current_user.id ).convert "#{@polish.tmp_folder}/layer_0.png", stack, @polish.coat_url(c)
    end
    generate_bottle
  end

  def generate_bottle
    bottle = Bottle.find(@polish.bottle_id)
    return true unless bottle    
    blur = bottle.blur > 5 ? " -blur 0x#{bottle.blur/10}" : ''
    
    stack = path + @polish.coat_url   
    (@polish.coats_count - 1).times{|c| stack += " #{path + @polish.coat_url( c + 1)} -composite "}       
    stack += " \\( +clone -resize 128x139 -gravity center -write #{path + @polish.preview_url} +delete \\) "
    stack = " \\( #{stack} \\) -resize 140x140\! -set option:distort:viewport 256x277-67-130 -virtual-pixel Mirror -filter point -distort SRT 0 +repage #{blur} "
    stack += " #{path + bottle.shadow_url} -channel RGB -compose Multiply -composite "
    stack += " #{path + bottle.highlight_url} -channel RGB -compose Screen -composite "
    stack = "\\( #{stack} \\( #{path + bottle.mask_url} -alpha copy \\) -compose Dstin -composite \\) -compose Over -composite "
    stack += " \\( +clone -resize 64x69^ -gravity center -extent 64x69 -write #{path + @polish.bottle_url('thumb', true)} +delete \\) "
    stack += " \\( +clone -resize 128x139^ -gravity center -extent 128x139 -write #{path + @polish.bottle_url('big', true)} +delete \\) "
    Magick.delay(queue: current_user.id).convert bottle.base_url, stack, @polish.bottle_url(nil, true)   
    @polish.delay(queue: current_user.id).update_attributes bottling_status: true
  end
  
  def all_layers_bottom_up
    @layers = @polish.layers.reject{|l| !l.new_record?}.sort{|a,b| a.ordering <=> b.ordering}
  end
  
end
