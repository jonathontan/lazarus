class BrandsController < ApplicationController
  def index
    @brands = Brand.all
  end

  def find_id
    @brand = Brand.find(params[:id])
  end

  def show
    redirect_to brands_path
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      redirect_to brand_products_path(@brand.id)
    else
      render :new
    end
  end

  def edit
    find_id
  end

  def update
    find_id

    if @brand.update(brand_params)
      redirect_to brands_path
    else
      render :edit
    end
  end

  def destroy
    Brand.find(params[:id]).destroy

    redirect_to brands_path
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end
end
