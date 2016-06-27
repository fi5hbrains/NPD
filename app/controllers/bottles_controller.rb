class BottlesController < ApplicationController
  
  before_action :set_bottle, only: [:show, :edit, :update, :destroy]
  
  def index
    @bottles = Bottle.all
  end
  
  def new
    set_brand
    @bottle = @brand.bottles.new
  end

  def edit
  end

  def create
    set_brand
    @bottle = @brand.bottles.new(bottle_params)
    @bottle.user_id = current_user.id
    @bottle.brand_slug = params[:brand_id]
    @bottle.layers = params[:bottle][:layers]
    if params[:preview]
      render :new
    else
      if @bottle.save
        redirect_to @brand
      else
        render :new
      end
    end
  end

  def update
    @bottle = Bottle.find(params[:id])
    @bottle.assign_attributes bottle_params
    @bottle.user_id = current_user.id
    @bottle.brand_slug = params[:brand_id]
    @bottle.layers = params[:bottle][:layers]
    if params[:preview]
      render :new
    else
      if @bottle.save
        redirect_to bottles_path
      else
        render :edit
      end
    end
  end

  def destroy
    set_brand
    FileUtils.rm_rf(path + '/' + @bottle.bottle_folder)
    @bottle_id = @bottle.id
    @bottle.destroy
    respond_to do |format|
      format.html { redirect_to edit_brand_path(@brand), method: :get, notice: 'Polish was successfully cloned.' }
      format.js
    end
  end
  
  private
  
  def bottle_params
    params.require(:bottle).permit(:name, :blur, :volume)
  end
  def set_brand; @brand = Brand.find_by_slug(params[:brand_id]) end
  def set_bottle; @bottle = Bottle.find(params[:id]) end
end
