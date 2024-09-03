# app/controllers/customers/carts_controller.rb
class Customers::CartsController < ApplicationController
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product_variant)
  end

  def add_to_cart
    variant_id = params[:product_variant_id]
    quantity = params[:quantity].to_i

    if quantity > 0
      product_variant = ProductVariant.find(variant_id)
      if product_variant && product_variant.stock >= quantity
        cart_item = @cart.cart_items.find_or_initialize_by(product_variant: product_variant)
        # Ensure quantity is initialized to 0 if it's nil
        cart_item.quantity ||= 0
        cart_item.quantity += quantity
        cart_item.save
        flash[:notice] = 'Item added to cart!'
      else
        flash[:alert] = 'Not enough stock available.'
      end
    else
      flash[:alert] = 'Invalid quantity.'
    end

    redirect_to customers_cart_path
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end
end
