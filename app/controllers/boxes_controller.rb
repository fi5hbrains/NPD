class BoxesController < ApplicationController
  include Slugify
  
  def show
    set_user
    cookies[:box_sort] ||= 'slug'
    set_box
    set_user_votes
  end
  
  def gather
    set_user
    set_box
    @addable = if @polishes.size > 0
      Polish.where('id NOT IN (?)', @box.polishes.pluck(:id))
    else
      Polish.where(nil)
    end.order('created_at ASC').page(params[:page_b]).per(12)
    render :show
  end
  
  def clear
    set_user
    set_box
    if @box.user_id == current_user.id
      @box.box_items.each &:destroy
    end
    render :show
  end
  
  def import
    @box = current_user.boxes.find_by_slug(params[:id])
    @box.import(params[:spreadsheet])
    @polishes = @box.polishes
  end
  
  def export
    set_user
    set_box
    case params[:button]
    when 'csv'
      send_data @box.export_csv(params[:colour], params[:bottle], params[:nail], params[:note], params[:rating], current_user.id), filename: @box.name + '.csv' and return
    when 'xlsx'
      @box.export_xlsx params[:colour], params[:bottle], params[:nail], params[:note], params[:rating], current_user.id
      # render plain: 'lalala'
      send_file Rails.root.join('public').to_s + "/downloads/#{@box.user_id}/#{@box.slug}.xlsx", type: "application/vnd.ms-excel" and return
    when 'image'
      # @box.export_image
      # send_file '/out.png', type: 'image/png', disposition: 'inline'
      columns = params[:columns].to_i
      columns = 9 if columns > 9 
      columns = 1 if columns < 1
      @box.export_image(@polishes, params[:bg_colour], columns, params[:note], params[:bottle], params[:nail], params[:rating])
      send_file Rails.root.join('public').to_s + "/downloads/#{@box.user_id}/#{@box.slug}.png", type: 'image/png', disposition: 'inline'
    end
  end
  
  def create
    if current_user && !params[:box].blank?
      box = Box.where(user_id: current_user.id, slug: slugify(params[:box])).first
      (@box = current_user.boxes.new(name: params[:box])).save unless box
    end
  end

  def update
    @box = Box.find(params[:id])
    @box.name = params[:box][:name]
    @box.save
  end
  
  def destroy
    set_user
    set_box
    if @box.user_id == current_user.id
      @box.destroy
    end
    redirect_to @user
  end
  
  private
  
  def set_box
    @box = @user.boxes.find_by_slug(params[:id])
    @polishes = @box.polishes.order(set_polish_sort)
    @brands = @polishes.pluck(:brand_id, :brand_name).uniq.sort{|a,b| a[1].mb_chars.downcase <=> b[1].mb_chars.downcase}
    @polishes = @polishes.page(params[:page]).per(15000)
    set_notes if @user == current_user
    @lists = @user.boxes    
  end
  
  def set_user
    @user = User.find_by_slug(params[:user_id])
  end
end