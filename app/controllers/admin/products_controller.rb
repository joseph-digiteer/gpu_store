class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin! # If you have authentication for admins
  include Pagy::Backend # Include Pagy backend methods

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    @variants = @product.product_variants # Ensure this line is fetching variants correctly
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    if @variant.update(variant_params)
      redirect_to admin_product_path(@variant.product), notice: 'Variant was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @variant.destroy
    redirect_to admin_product_path(@variant.product), notice: 'Variant was successfully deleted.'
  end

  private

  def set_variant
    @variant = ProductVariant.find(params[:id])
  end

  def variant_params
    params.require(:product_variant).permit(:name, :description, :price, :stock)
  end
end
