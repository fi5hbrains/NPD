class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Slugify

  before_filter :no_cache_on_ajax
  helper_method :current_user_session, :current_user, :in_lab?, :set_catalogue_icons

  def set_users signables; User.find(signables.pluck(:user_id)) end
  def set_brand; @brand = Brand.find_by_slug(slugify params[:brand_id]) end
  def set_bottles; @bottles = (Bottle.where(brand_slug: 'default') + @brand.bottles).uniq end
  def set_user_votes; @user_votes = current_user.try(:votes) end
  def set_collections
    if current_user
      %w(Collection Wishlist Giveaway).each do |name|
        instance_variable_set "@#{name}", current_user.boxes.find_or_create_by(name: name).box_items
      end
    end
  end
  def search brand = nil, colour = nil, spread = nil, sort = nil, page = nil, per = nil
    @reset = false
    colour ||= params[:colour]
    spread ||= params[:spread]
    if brand || params[:brand_id]
      brand = Brand.find_by_slug(brand || params[:brand_id])
    elsif @brand
      brand = @brand
    end
    @polish = Polish.find_by_slug(params[:polish_id]) if params[:polish_id]
    polish_id = (@polish.try(:id) || 0)
    colour ||= [@polish.h, @polish.s, @polish.l] if @polish && spread
    sort ||= cookies[:polish_sort]
    page ||= params[:page]
    per ||= 48
    
    if !params[:brand].blank?
      brand_ids = Synonym.where("name ilike ? AND word_type = 'Brand'", "%#{params[:brand] || ''}%").
        pluck('word_id').compact.uniq
      @brands = Brand.where(id: brand_ids).sort_by_polishes_count
      if @brands.size > 0
        brand = Brand.find_by_name(params[:brand]) 
      end
    end
    if !params[:polish].blank? || brand || colour
      if params[:polish] 
        polish_ids = Synonym.
          where("name ilike ? AND word_type = 'Polish'", "%#{params[:polish]}%").
          pluck('word_id').compact.uniq
      else
        polish_ids = []
      end
      polishes = brand ? brand.polishes : @brands ? Polish.where(brand_id: @brands.pluck(:id)) : Polish.where(nil)
      @polishes = polishes.
        where( (polish_ids.empty? ? '' : "id IN (#{polish_ids.inspect.gsub('[', '').gsub(']','')}) OR ") + 
        "number ilike ? OR slug ilike ?", "%#{params[:polish]}%", "#{params[:polish]}%").
        where(draft: false).
        where('id != ?', polish_id)
    elsif params[:polish].blank?
      if params[:action] == 'search'
        @reset = true unless params[:brand_id]
      else
        @polishes = Polish.where(draft: false)
      end
    else
      @reset = true
    end
    if @reset && params[:action] == 'search'
      render js: "window.location.href = '#{env["HTTP_REFERER"].split('?')[0].to_s }'"
    elsif params[:action] == 'search' && brand && params[:polish].blank? && params[:colour].blank?
      render js: "window.location.href = '/catalogue/#{brand.slug}'"
    else
      if @polishes && colour
        @polishes = @polishes.coloured( colour, spread )
      end
      if @polishes
        @polishes = @polishes.order(sort).page(page).per(per)
      end
    end
  end
  
  def lab_search
    @reset = false
    params[:lab] = true
    polish_filter = (cookies[:lab_polish_filter] == 'bottle' ? {bottle_id: 63} : cookies[:lab_polish_filter] == 'draft' ? {draft: true} : nil)
    if !params[:brand].blank?
      brand_ids = Synonym.where("name ilike ? AND word_type = 'Brand'", "%#{params[:brand] || ''}%").
        pluck('word_id').compact.uniq
      @brands = Brand.
        where(id: brand_ids).
        where('slug != ?', params[:brand_id] || '=').
        sort_by_polishes_count.first(10)
    elsif !params[:polish].blank?
      polish_ids = Synonym.
        where("name ilike ? AND word_type = 'Polish'", "%#{params[:polish]}%").
        pluck('word_id').compact.uniq  
      @polishes = Polish.
        where(polish_filter).
        where(brand_slug: (slugify( params[:brand_id] || params[:id]))).
        where((polish_ids.blank? ? "number ilike ?" : "id IN (#{polish_ids.inspect.gsub('[', '').gsub(']','')}) OR number ilike ?"), "%#{params[:polish]}%").
        where('slug != ?', params[:polish_id] || '-').
        order('updated_at desc')
    elsif %w(brands polishes).include? params[:controller]
      @polishes = @brand.polishes.where(polish_filter).order('updated_at desc')
    else
      @reset = true
    end
    return @polishes
  end
  
  def collection_search
    @reset = false
    @box ||= Box.find(params[:box_id])
    cookies[:box_sort] = params[:box_sort] unless params[:box_sort].blank?
    @brand_ids = params[:filter_brand].class.name == 'String' ? params[:filter_brand].split('-') : params[:filter_brand].try(:keys)
    set_user_votes
    if !params[:polish].blank?
      @box = Box.find(params[:box_id])
      box_polish_ids = @box.polishes.map(&:id)
      unless box_polish_ids.blank?
        polish_ids = Synonym.
          where("word_type = 'Polish' AND word_id IN (#{box_polish_ids.inspect.gsub('[', '').gsub(']','')})").
          where("name ilike ? AND word_type = 'Polish'", "%#{params[:polish]}%").
          pluck('word_id').compact.uniq
        @polishes = if @brand_ids.blank?
          Polish.where(nil)
        else
          Polish.where(brand_id: @brand_ids)
        end
        @polishes = if polish_ids.blank?
          @polishes.
            where("(id IN (#{box_polish_ids.inspect.gsub('[', '').gsub(']','')}) AND number ilike ?)", "%#{params[:polish]}%")
        else
          @polishes.
            where("id IN (#{polish_ids.inspect.gsub('[', '').gsub(']','')}) OR (id IN (#{box_polish_ids.inspect.gsub('[', '').gsub(']','')}) AND number ilike ?)", "%#{params[:polish]}%")
        end.order(set_polish_sort).first(24)
      end
    else
      @reset = true
      @polishes = if @brand_ids.blank?
        @box.polishes
      else
        @box.polishes.where(brand_id: @brand_ids)
      end.order(set_polish_sort).page(params[:page])
    end
  end
  def collect_search
    @reset = false
    if !(params[:polish].blank? && params[:brand].blank?) 
      @box = Box.find(params[:box_id])
      box_polish_ids = @box.polishes.map(&:id)
      if !params[:brand].blank?
        brand_ids = Synonym.where("name ilike ? AND word_type = 'Brand'", "%#{params[:brand]}%").
          pluck('word_id').compact.uniq
      end
      if params[:brand].blank? || !brand_ids.empty?
        polish_ids = if !params[:polish].blank?
          Synonym.
            where("name ilike ? AND word_type = 'Polish'", "%#{params[:polish]}%").
            pluck('word_id').compact.uniq
        else
          []
        end
        @polishes = Polish.
          where(brand_ids ? {brand_id: brand_ids} : nil).
          where( (polish_ids.empty? ? '' : "id IN (#{polish_ids.inspect.gsub('[', '').gsub(']','')}) OR ") + 
          "slug ilike ?", "#{params[:polish] || ''}%").        
          where(box_polish_ids.empty? ? nil : ['id NOT IN (?)', box_polish_ids]).
          order('created_at ASC')
        if @polishes.size > 12
          @next_item = @polishes[12]
          @polishes = @polishes[0..11]
        end  
      else
        @polishes = []
      end
    else
      @reset = true
    end
  end
  def autocomplete
    @id = params[:id]
    unless params[:brand].blank?
      brand_ids = Synonym.where(word_type: 'Brand').where("name ilike ?", "%#{params[:brand] || ''}%").pluck(:word_id).uniq
      @brands = Brand.where(id: brand_ids)
      @brand_names = @brands.pluck(:name)
      @unfit_brand_names = @brand_names.reject{|name| /#{Regexp.quote params[:brand]}/i.match(name)}
    end
    @brand_names ||= []

    # if !params[:polish].blank?
    #   @polishes = Polish.where(@brands ? {brand_id: @brands.pluck(:word_id)} : nil).coloured(params[:colour]) 
    #   polish_ids = @polishes.pluck(:id)
    #   @polish_names = (
    #     @polishes.where("number ilike ?","%#{params[:polish] || ''}%").
    #     pluck(:number) + 
    #     Synonym.where(word_type: 'Polish', word_id: polish_ids).
    #     where("name ilike ?","%#{params[:polish] || ''}%").
    #     pluck(:name)).compact.uniq
    # end
    # @polish_names ||= []
  end

  def path; Rails.root.join('public').to_s end
  def in_lab?; params[:lab] end
  def in_box? box, polish; (box || []).detect{|item| item.polish_id == polish.id} end 
  def set_polish_sort
    case cookies[:box_sort]
    when 'slug'; 'slug ASC'
    when 'rating'; 'rating DESC'
    when 'colour'; 'h ASC'
    when 'created_at'; 'box_items.created_at ASC' end
  end
  
  def charming_charlie colour = nil
    colour ||= (params[:colour] || 'blue')
    agent = Mechanize.new
    page = agent.get( 'http://www.charmingcharlie.com/catalogsearch/result/?q=' + colour)
    items = page.search('.item')
    indices = (0..(items.size - 1)).to_a.sample(2)
    @result = []
    indices.each do |i|  
      item = items[i]
      images = item.search('img')
      link = item.at('a').attr('href')
      name = item.at('.product-name').at('a').text
      price = item.at('.price').text
      @result << {image: images.first.attr('data-yo-src'), hover: images.size > 1,  link: link, name: name, price: price}
    end
    return @result
  end
  private
  
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end
  
  def no_cache_on_ajax
    if request.xhr?
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end
  
end
