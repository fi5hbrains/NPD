class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Slugify

  helper_method :current_user_session, :current_user, :in_lab?, :coat, :set_catalogue_icons

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
  def search brand = nil, colour = nil, spread = nil, sort = nil
    colour ||= params[:colour]
    spread ||= params[:spread]
    brand = Brand.find(params[:brand_id]) if params[:brand_id]
    @brand ||= brand
    @polish = Polish.find(params[:polish_id]) if params[:polish_id]
    polish_id = (@polish.try(:id) || 0)
    colour ||= [@polish.h, @polish.s, @polish.l] if @polish && spread
    
    if !params[:brand].blank?
      brand_ids = Synonym.where("name ilike ? AND word_type = 'Brand'", "%#{params[:brand] || ''}%").
        pluck('word_id').compact.uniq
      @brands = Brand.where(id: brand_ids).sort_by_polishes_count
      @brand = @brands.first if @brands.count == 1
    end
    if !params[:polish].blank? || @brand || colour
      if params[:polish] 
        polish_ids = Synonym.
          where("name ilike ? AND word_type = 'Polish'", "%#{params[:polish]}%").
          pluck('word_id').compact.uniq
      else
        polish_ids = []
      end
      polishes = @brands ? Polish.where(brand_id: @brands.pluck(:id)) : @brand ? @brand.polishes : Polish.where(nil)
      @polishes = polishes.
        where( (polish_ids.empty? ? '' : "id IN (#{polish_ids.inspect.gsub('[', '').gsub(']','')}) OR ") + 
        "slug ilike ?", "#{params[:polish] || ''}%").
        where(draft: false).
        where('id != ?', polish_id)
    elsif params[:polish].blank?
      @polishes = Polish.where(draft: false)
    end
    if @polishes && colour
      @polishes = @polishes.coloured( colour, spread )
    end
    if @polishes && sort
      @polishes = @polishes.order(sort)
    end
  end
  
  def lab_search
    @reset = false
    if params[:brand]
      brand_ids = Synonym.where("name ilike ? AND word_type = 'Brand'", "%#{params[:brand] || ''}%").
        pluck('word_id').compact.uniq
      @brands = Brand.
        where(id: brand_ids).
        where('id != ?', params[:brand_id] || 0).
        sort_by_polishes_count.first(10)
    elsif params[:polish]
      polish_ids = Synonym.
        where("name ilike ? AND word_type = 'Polish'", "%#{params[:polish]}%").
        pluck('word_id').compact.uniq  
      @polishes = Polish.
        where(brand_id: (params[:brand_id] || params[:id])).
        where("id IN (#{polish_ids.inspect.gsub('[', '').gsub(']','')}) OR slug ilike ?", "#{params[:polish]}%").
        where('id != ?', params[:polish_id] || 0).
        order('created_at desc')
    else
      @reset = true
    end
  end
  
  def autocomplete
    @id = params[:id]
    if !params[:brand].blank?
      @brands = Synonym.where(word_type: 'Brand').where("name ilike ?", "%#{params[:brand] || ''}%")
      @brand_names = @brands.pluck(:name)
    end
    if !params[:polish].blank?
      @polishes = Polish.where(@brands ? {brand_id: @brands.pluck(:word_id)} : nil).coloured(params[:colour]) 
      polish_ids = @polishes.pluck(:id)
      @polish_names = (
        @polishes.where("number ilike ?","%#{params[:polish] || ''}%").
        pluck(:number) + 
        Synonym.where(word_type: 'Polish', word_id: polish_ids).
        where("name ilike ?","%#{params[:polish] || ''}%").
        pluck(:name)).compact.uniq
    end
    @brand_names ||= []
    @polish_names ||= []
  end

  def path; Rails.root.join('public').to_s end
  def in_lab?; params[:lab] end
  def in_box? box, polish; (box || []).detect{|item| item.polish_id == polish.id} end 
  
  private
  
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end
  
end
