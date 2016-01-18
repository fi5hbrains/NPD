class BottlesController < ApplicationController
  
  before_action :set_bottle, only: [:show, :edit, :update, :destroy]
  before_action :set_brand
  
  def new
    @bottle = @brand.bottles.new
  end

  def edit
  end

  def create
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
    if @bottle.update_attributes(bottle_params)
      Magick.convert "\"#{bottle_parts_path + @bottle.base_url.split('/').last}\"","-resize '50x64^'", "\"#{Rails.root.to_s}/public#{@bottle.base_thumb_url}\""      
      redirect_to brand_path(params[:brand_id]), notice: @bottle.name + ' bottle was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  def destroy
    FileUtils.rm_rf( path + @bottle.bottle_folder )
    @bottle_id = @bottle.id
    @bottle.destroy
    respond_to do |format|
      format.html { redirect_to edit_brand_path(@brand), method: :get, notice: 'Polish was successfully cloned.' }
      format.js
    end
  end
  private
  def bottle_params
    params.require(:bottle).permit(:name, :blur)
  end
  def set_brand; @brand = Brand.find_by_slug(params[:brand_id]) end
  def set_bottle; @bottle = Bottle.find(params[:id]) end
end
