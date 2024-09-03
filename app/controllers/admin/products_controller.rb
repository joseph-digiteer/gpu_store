class Admin::ProductsController < ApplicationController
  include Pagy::Backend
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @product_series = Product.all

    if params[:search].present?
      @product_series = @product_series.where('name ILIKE ?', "%#{params[:search]}%")
    end
  end
  
  def show
    @variants = @product.product_variants.where(active: true)
  end

  def new
    @product = Product.new
    @product.product_variants.build
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product), notice: 'Product series was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: 'Product series was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_url, notice: 'Product series was successfully destroyed.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :active, product_variants_attributes: [:id, :name, :description, :price, :stock, :active, :_destroy])
  end
end
