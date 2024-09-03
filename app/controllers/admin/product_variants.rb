class Admin::ProductVariantsController < ApplicationController
  def new
    @product = Product.new
    @product.product_variants.build # Initialize an empty variant
  end

  def edit
    @product.product_variants.build if @product.product_variants.empty? # Ensure at least one variant is present
  end
end