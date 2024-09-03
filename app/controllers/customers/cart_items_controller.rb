# app/controllers/customers/cart_items_controller.rb
class Customers::CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @cart = current_user.cart || current_user.create_cart
  
    product_variant = ProductVariant.find(params[:product_variant_id])
    quantity = params[:quantity].to_i
  
    cart_item = @cart.cart_items.find_or_initialize_by(product_variant: product_variant)
  
    if cart_item.persisted?
      cart_item.quantity += quantity
    else
      cart_item.quantity = quantity
    end
  
    # Ensure cart_item is associated with the customer
    cart_item.customer = current_user.customer
  
    if cart_item.save
      flash[:notice] = "Item added to cart."
    else
      flash[:alert] = "Unable to add item to cart."
      Rails.logger.debug "Errors: #{cart_item.errors.full_messages.join(', ')}"
    end
  
    redirect_to customers_cart_path
  end
  
  
  def update
    @cart = current_user.cart || current_user.create_cart
    cart_item = @cart.cart_items.find(params[:id])
  
    if cart_item.update(cart_item_params)
      flash[:notice] = 'Cart item updated successfully.'
    else
      flash[:alert] = 'Unable to update cart item.'
    end
  
    redirect_to customers_cart_path
  end

  def destroy
    @cart = current_user.cart || current_user.create_cart
    cart_item = @cart.cart_items.find(params[:id])
  
    if cart_item.destroy
      flash[:notice] = 'Cart item removed.'
    else
      flash[:alert] = 'Unable to remove cart item.'
    end
  
    redirect_to customers_cart_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end

  def authenticate_user!
    redirect_to new_user_session_path unless user_signed_in?
  end
end
