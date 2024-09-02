class Admin::ProductsController < ApplicationController
  include Pagy::Backend
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @q = Product.ransack(params[:q])
    @pagy, @products = pagy(@q.result(distinct: true).where(active: true), items: 15)
  end

  def show
    @variants = @product.product_variants.where(active: true)
  end

  def new
    @product = Product.new
    @product.product_variants.build # Initialize an empty variant for new products
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product), notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
    @product.product_variants.build if @product.product_variants.empty? # Build an empty variant if none exist
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_url, notice: 'Product was successfully destroyed.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :active, product_variants_attributes: [:id, :name, :description, :price, :stock, :active, :_destroy])
  end
end
