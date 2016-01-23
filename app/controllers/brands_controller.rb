class BrandsController < ApplicationController
  def index
    Brand.new(name: 'Default', user_id: current_user.id).save if Brand.count == 0
    @brands = Brand.all.sort_by_polishes_count.page(params[:page]).per(10)
  end

  def show
    set_brand    
    set_bottles
    params[:polish] ? lab_search : @polishes = @brand.polishes.order('created_at desc')
    @polishes = @polishes.page(params[:page]).per(12)
    render 'catalogue_show' if !in_lab?
  end

  def new
    @brand = Brand.new
  end

  def edit
    set_brand
    set_bottles
  end

  def create
    @brand = Brand.new(brand_params)
    set_name
    @brand.user_id = current_user.id

    respond_to do |format|
      if @brand.save
        format.html { redirect_to brand_path(@brand), notice: 'Brand was successfully created.' }
        format.json { render :show, status: :created, location: @brand }
      else
        format.html { render :new }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_brand
    set_name
    respond_to do |format|
      if @brand.update(brand_params)
        format.html { redirect_to brand_path(@brand), notice: 'Brand was successfully updated.' }
        format.json { render :show, status: :ok, location: @brand }
      else
        format.html { render :edit }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    set_brand
    FileUtils.rm_rf(path + @brand.folder)
    @brand.destroy
    respond_to do |format|
      format.html { redirect_to brands_url, notice: 'Brand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_name
    @brand.name = params[:brand][:synonym_list].split(';')[0].try(:strip)
  end

  def brand_params
    params.require(:brand).permit(:synonym_list, :link)
  end
end
