class AdsController < ApplicationController
  before_action :set_ad, only: [:show, :edit, :update, :destroy]

  def index
    @ads = Ad.all.order('updated_at Desc')
  end

  def show
  end

  def new
    @ad = Ad.new
  end

  def edit
  end

  def create
    if current_user && current_user.slug == 'bobin'
      @ad = Ad.new(ad_params)
  
      respond_to do |format|
        if @ad.save
          format.html { redirect_to @ad, notice: 'Ad was successfully created.' }
          format.json { render :show, status: :created, location: @ad }
        else
          format.html { render :new }
          format.json { render json: @ad.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  def update
    respond_to do |format|
      if @ad.update(ad_params)
        format.html { redirect_to @ad, notice: 'Ad was successfully updated.' }
        format.json { render :show, status: :ok, location: @ad }
      else
        format.html { render :edit }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to ads_url, notice: 'Ad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_ad
      @ad = Ad.find(params[:id])
    end

    def ad_params
      params.require(:ad).permit(:name, :h_range, :s_range, :l_range, :o_range, :image, :image_hover, :omni, :link, :subtitle)
    end
end
