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
      @versions = @polish.versions
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
    @polish.generate_preview @layers
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
        polishes = Polish.where('id NOT IN (?)', collection.map( &:polish_id)).first(12 * (params[:page_b] || 1).to_i + 1)
        @next_item = polishes.last if polishes.count > 12
        @added_item = Polish.find(@item.polish_id)
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
      @polish.generate_preview @layers, params[:changes]
      respond_to do |format|
        format.html {render :new}
        format.js {render 'preview'}
      end
    elsif @polish.valid?
      @polish.bottling_status = false
      @polish.save_version('create')
      @polish.generate_preview @layers, params[:changes]
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
    old_owner = @polish.user_id
    @polish.assign_attributes polish_params
    set_name
    set_crackle
    @polish.brand_name = @brand.name
    @polish.brand_slug = @brand.slug
    all_layers_bottom_up
    if params[:preview]
      @polish.generate_preview @layers, params[:changes]
      respond_to do |format|
        format.html {render :edit}
        format.js {render 'preview'}
      end
    elsif @polish.valid?
      @polish.bottling_status = false
      rename_polish_files old_slug if old_slug != @polish.slug
      @polish.draft = params[:polish][:draft] == '1'
      @polish.save_version( params[:redress] ? 'redress' : 'update')
      @polish.user_id = current_user.id
      @polish.notify
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
        @polish.generate_preview @layers, params[:changes]
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
    @copy.user_id = current_user.id
    @copy.save
    @copy.save_version('clone')
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

  def all_layers_bottom_up
    @layers = @polish.layers.reject{|l| !l.new_record? || l._destroy}.sort{|a,b| a.ordering <=> b.ordering}
  end
  
  def clear_tmp_folder
    FileUtils.rm Dir.glob(path + @polish.tmp_folder + '/*')
  end
end