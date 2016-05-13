class PolishesController < ApplicationController
  include Slugify, ColourMethods, MagickMethods

  def index
    set_brand
    search
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
      @colour_names = get_colour_names([@polish.h,@polish.s,@polish.l])
      find_related @polish
      render 'catalogue_show'
    else
      @polishes = lab_search.page(params[:page]).per(Defaults::PER[:lab_polishes])
    end
  end
  
  def new
    set_brand
    set_bottles
    @polish = Polish.new
    @polish.bottle_id = params[:bottle] || Brand.find_by_slug('default').bottles.first.id
    @polish.user_id = current_user.id
    @polish.layers.new(layer_type: 'base')
    clear_tmp_folder
    all_layers_bottom_up
    @polishes = lab_search.page(params[:page]).per(Defaults::PER[:lab_polishes])
  end

  def edit
    set_polish
    set_bottles
    clear_tmp_folder
    @polish.bottle_id ||= Brand.find_by_slug('default').bottles.first.id
    @polish.user_id = current_user.id
    @polishes = lab_search.page(params[:page]).per(Defaults::PER[:lab_polishes])
    @polish.layers.new(layer_type: 'base') if @polish.layers.size < 1
    @layers = @polish.layers.map(&:dup).reject{|l| !l.new_record?}.sort{|a,b| a.ordering <=> b.ordering}
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
        @user_votes = current_user.votes.where(votable_type: 'Polish', votable_id: params[:polish_id])
        @polishes = Polish.where('id NOT IN (?)', collection.map( &:polish_id)).page(params[:page_b]).per(12)
        @next_item = @polishes.last if @polishes.count >= 12
        @added_item = Polish.find(@item.polish_id)
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
    set_crackle
    all_layers_bottom_up
    if params[:preview]
      generate_preview params[:changes]
      respond_to do |format|
        format.html {render :new}
        format.js {render 'preview'}
      end
    elsif @polish.valid?
      @polish.bottling_status = false
      generate_preview params[:changes]
      @polish.save
      @polish.delay(queue: current_user.id).flatten_layers @layers
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
    set_crackle
    @polish.brand_name = @brand.name
    @polish.brand_slug = @brand.slug
    @polish.user_id = current_user.id
    all_layers_bottom_up
    if params[:preview]
      generate_preview params[:changes]
      respond_to do |format|
        format.html {render :edit}
        format.js {render 'preview'}
      end
    elsif @polish.valid?
      @polish.bottling_status = false
      rename_polish_files old_slug if old_slug != @polish.slug
      @polish.draft = params[:polish][:draft] == '1'
      @polish.save_version( params[:redress] ? 'redress' : 'update')
      if params[:redress]
        if old_bottle_id != @polish.bottle_id
          @polish.generate_bottle(true) 
        else
          @polish.bottling_status = true
        end
        @polish.save
        redirect_to @brand, notice: 'Polish was successfully updated.' 
      else
        @polish.layers.each{|l| l.destroy unless @layers.map(&:id).include?(l.id) || l.new_record?}
        generate_preview params[:changes]
        @polish.save
        @polish.delay(queue: current_user.id).flatten_layers @layers
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
    @copy.assign_attributes YAML.load( @polish.to_yaml )
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
    set_user_votes
    cookies[:spread] = params[:spread].to_i if params[:spread]
    @polish = polish || (Polish.find(params[:polish_id]) if params[:polish_id])
    spread = spread || cookies[:spread] || 20
    @related = Polish.
      coloured( [@polish.h, @polish.s, @polish.l, @polish.opacity], spread)
  end
  
  def reorder
    params[:lab] = false
    search
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
  def set_crackle
    if params[:polish][:crackle_type].blank?
      @polish.crackle_type = nil
    end
  end
  def polish_params
    if params[:yaml].blank?
      params.require(:polish).permit(
        :prefix, :name, :synonym_list, :number, :release_year, :collection, :bottle_id, :gloss_type, :crackle_type,
        :gloss_colour, :opacity, :reference, :remote_reference_url, :remove_reference, :reference_cache,
        {layers_attributes: [ 
          :layer_type, :ordering, :c_base, :c_duo, :c_multi, :c_cold, 
          :highlight_colour, :shadow_colour, :opacity, :particle_type, :particle_size, 
          :particle_density, :holo_intensity, :thickness, :magnet_intensity, :_destroy 
        ]})
      else
        polish_hash = YAML.load(params[:yaml])
        polish_hash = polish_hash.select {|k,v| %w(prefix name synonym_list number release_year collection bottle_id gloss_type gloss_colour opacity layers_attributes).include?(k)}
        polish_hash['layers_attributes'].each do |key,val|
          polish_hash['layers_attributes'][key] = val.select {|k,v| %W(layer_type ordering c_base c_duo c_multi c_cold  highlight_colour shadow_colour opacity particle_type particle_size particle_density holo_intensity thickness magnet_intensity).include?(k)}
        end
        return polish_hash
      end
  end
    
  def rename_polish_files old_slug, polish = nil
    copy = polish.present?
    polish ||= @polish

    unless polish.draft
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
  end

  def generate_preview changed_layers = {}
    tmp_folder = @polish.tmp_folder
    reflection = @polish.gloss_tmp
    parts = "/assets/polish_parts/"
    
    c_duo = "#{parts}colour_duo.png"
    c_multi = "#{parts}colour_multi.png"
    c_cold = "#{parts}colour_cold.png"
    opacity_mask = "#{parts}opacity_#{(((@polish.opacity || 100) / 10).round * 10).to_s}.png"
    magnet = "#{tmp_folder}/magnet.png"
    holo = "#{parts}holo_default.png"
    mask = @polish.opacity_mask
        
    @polish.magnet ||= 'blank'
    old_coats_count = @polish.coats_count
    @polish.coats_count = (1 + 8 * (100 - (@polish.opacity || 100)) / 100).round
    
    noise_density = {'shimmer' => 0, 'flake' => 0, 'glitter' => 0}
    noise_size = {'shimmer' => 0, 'flake' => 0, 'glitter' => 0}
    sand_ordering = 0
    sand_size = 0
    sand_density = 0
    top_layer = 'base'
    sand_layer = @layers.select{|l| l.layer_type == 'sand'}.first

    FileUtils.mkdir_p(path + tmp_folder)  
    
    @layers.each_with_index do |layer, i|
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

      if !layer.frozen? && (!changed_layers[layer.ordering.to_s].blank? && changed_layers[layer.ordering.to_s] != 0 || old_coats_count < @polish.coats_count)
        base = @polish.layer_tmp(layer.ordering)
        layer.opacity ||= 100
        
        if layer.layer_type == 'flake'
          flake_shadow_tmp = "#{tmp_folder}/layer_#{layer.ordering}_flake_shadow.mpc"
          mask = parts + 'flake_' + (layer.particle_size / 34 * 50).to_s + 
            '_' + ((layer.particle_density / 10.0).round * 10).to_s + '.png'
          Magick.convert mask + ' -page +0+1 -background none -flatten -blur 0x3 ', '\\( ' + path + mask + ' -negate \\) -compose Multiply -composite -brightness-contrast -20 ', flake_shadow_tmp
        end
        
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
          
          multiplyer = (layer.particle_density * 4.7 / particle_scale).round + rand(2)
          scale_offset = 50
          x_offset = 0 
          shadow_shift_x = 0
          shadow_shift_y = 2
          
          mask_stack      = []
          holo_stack      = []
          highlight_stack = []
          shadow_stack    = []
        end
        
        (@layers.size > 1 ? @polish.coats_count : 1).times do |c| 
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
              mask             = "#{tmp_folder}/layer_#{layer.ordering.to_s}_mask.png"
              particles_hl     = "#{tmp_folder}/layer_#{layer.ordering.to_s}_highlight.png"
              holo             = "#{tmp_folder}/layer_#{layer.ordering.to_s}_holo.png"
              particles_shadow = "#{tmp_folder}/layer_#{layer.ordering.to_s}_particles_shadow.png"

              mask_stack[c]      = ''
              shadow_stack[c]    = ''
              highlight_stack[c] = ''            
              holo_stack[c]      = ''   

              size = layer.particle_size         
              
              multiplyer.to_i.times do
                rnd_x = rand(Defaults::CANVAS[0] - 2 * x_offset ) + x_offset - 96 * size / 100 + 10
                scl_x = 100 * Math.sin(Math::PI*(rnd_x + 128 * size / 100 + scale_offset)/(Defaults::CANVAS[0] + 2 * scale_offset ))
                rnd_y = rand(Defaults::CANVAS[1]) - 128 * size / 100 
                rnd_r = rand(80) - 40   
                
                shape_transform = "-rotate #{rnd_r} -scale #{scl_x}%x100%"
                shape_adjust = "#{path + shape_tmp} -background black #{shape_transform} -geometry +#{rnd_x}+#{rnd_y}"
                mask_stack[c] += " \\( #{shape_adjust} -background white -alpha shape \\) -compose dissolve -define compose:args=#{layer.opacity} -composite "
                shadow_stack[c] += " \\( #{path + shape_shadow_tmp} -background black #{shape_transform} -geometry +#{rnd_x + shadow_shift_x}+#{rnd_y + shadow_shift_y} \\) -compose Screen -composite \\( #{shape_adjust} -negate \\) -compose Multiply -composite "
                highlight_stack[c] += " \\( \\( #{shape_adjust} -alpha copy \\) \\( #{path + particle_hl} -geometry -#{rnd_x}-#{rnd_y} \\) -compose In -composite \\) -alpha on -compose Over -composite "
                holo_stack[c] += " \\( \\( #{shape_adjust} -alpha copy \\) \\( #{path + particle_holo} -geometry -#{rand(572 - 256 * size / 100)}-#{rand(900 - 256 * size / 100)} \\) -compose In -composite \\) -alpha on -compose Over -composite "
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
                Magick.delay( queue: current_user.id, layer_ordering: layer.ordering ).convert fill('black'), mask_stack[c], mask                
                Magick.delay( queue: current_user.id, layer_ordering: layer.ordering ).convert fill('black'), shadow_stack[c], particles_shadow
                Magick.delay( queue: current_user.id, layer_ordering: layer.ordering ).convert fill('rgba(0,0,0,0)'), highlight_stack[c], particles_hl
                Magick.delay( queue: current_user.id, layer_ordering: layer.ordering ).convert fill('rgba(0,0,0,0)'), holo_stack[c], holo  if layer.holo_intensity > 0
              end
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
                  magnet = @polish.magnet
                  Magick.convert base, '-compose dissolve -define compose:args=' + layer.magnet_intensity.to_s, @polish.magnet_url(base,magnet)
                end
              else
                Magick.delay( queue: current_user.id, layer_ordering: layer.ordering ).convert(fill(layer.c_base), convert_list , coat(base, c))
                if layer.magnet_intensity > 0
                  Defaults::MAGNETS.each do |magnet|
                    Magick.delay( queue: current_user.id, layer_ordering: layer.ordering ).convert base, '-compose dissolve -define compose:args=' + layer.magnet_intensity.to_s, @polish.magnet_url(base,magnet) unless magnet == @polish.magnet
                  end
                end
              end
            end
          end
        end
      end
      if @polish.crackle_type
        Magick.convert @polish.layer_tmp(layer.ordering), "\\( #{path + parts}mask_#{@polish.crackle_type}.png -negate -background black -alpha shape \\) -compose DstOut -composite ", @polish.crackled_url(@polish.layer_tmp(layer.ordering))
      end
    end
    
    ref_type = @polish.gloss_type
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
      if sand_ordering < (@layers.size - 1)
        # todo generate upper layers mask > combine sand_ref & ref_source > generate reflection
      end

      Magick.convert parts + sand_ref, "+level-colors ,'#{@polish.gloss_colour}'", reflection  

    else
      Magick.convert parts + ref_source, "+level-colors ,'#{@polish.gloss_colour}'" + (@polish.crackle_type ? " #{path + parts}mask_#{@polish.crackle_type}.png -compose Multiply -composite" : ''), reflection   
    end
  end

  def all_layers_bottom_up
    @layers = @polish.layers.reject{|l| !l.new_record? || l._destroy}.sort{|a,b| a.ordering <=> b.ordering}
  end
  
  def clear_tmp_folder
    FileUtils.rm Dir.glob(path + @polish.tmp_folder + '/*')
  end
end