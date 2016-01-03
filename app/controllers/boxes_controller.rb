class BoxesController < ApplicationController
  include Slugify
  before_action :set_user
  
  def show
    set_box
  end
  
  def gather
    set_box
    @addable = if @polishes.size > 0
      Polish.where('id NOT IN (?)', @box.polishes.pluck(:id))
    else
      Polish.where(nil)
    end.page(params[:page_b]).per(12)
    render :show
  end
  
  def import
    @box = current_user.boxes.find_by_slug(params[:id])
    @box.import(params[:spreadsheet])
    @polishes = @box.polishes
  end
  
  def export
    set_box
    respond_to do |format|
      format.csv { send_data @box.export }
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
  
  private
  
  def set_box
    @box = @user.boxes.find_by_slug(params[:id])
    @polishes = @box.polishes.page(params[:page])
    @brands = Brand.find @polishes.pluck(:brand_id).uniq
    @lists = @user.boxes    
  end
  
  def set_user
    @user = User.find_by_slug(params[:user_id])
    set_user_votes if @user == current_user
  end
end