class BoxesController < ApplicationController
  before_action :set_user
  
  def show
    set_box
  end
  
  def gather
    set_box
    if @polishes.count > 0
      @addable = Polish.where('id NOT IN (?)', @polishes.map( &:id)).page(params[:page_b]).per(12)
    else
      @addable = Polish.page(params[:page_b]).per(12)
    end
    render :show
  end
  
  def import
    @box = current_user.boxes.find_by_slug(params[:id])
    @box.import(params[:spreadsheet])
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