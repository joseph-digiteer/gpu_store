class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin! # If you have authentication for admins
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_existing_products, only: [:new, :create, :edit, :update]
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
    @product.product_variants.build # to create at least one variant field
  end
  
  def create
    if params[:product][:existing_series].present?
      # Adding variants to an existing series
      @product = Product.find(params[:product][:existing_series])
      @product.assign_attributes(product_params)
    else
      # Creating a new series
      @product = Product.new(product_params)
    end

    if @product.save
      redirect_to admin_products_path, notice: 'Product series was successfully created.'
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: 'Product updated successfully.'
    else
      render :edit
    end
  end

  def update_variant
    if @variant.update(variant_params)
      redirect_to admin_product_path(@product), notice: 'Product variant updated successfully.'
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

  def set_product
    @product = Product.find(params[:id])
  end

  def set_existing_products
    @existing_products = Product.all
  end

  def product_params
    params.require(:product).permit(:name, :description, :active, product_variants_attributes: [:id, :name, :description, :price, :stock, :active, :_destroy])
  end

  def variant_params
    params.require(:product_variant).permit(:name, :description, :price, :stock, :active)
  end
  
end
