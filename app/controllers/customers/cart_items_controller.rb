class Customers::CartItemsController < ApplicationController
  #run authenticate_user func 1st
  before_action :authenticate_user!

  def create
    @cart = current_user.cart || current_user.create_cart
    # search in product variants its ID
    product_variant = ProductVariant.find(params[:product_variant_id])
    #then the quantity it has and update it
    quantity = params[:quantity].to_i

    cart_item = @cart.cart_items.find_or_initialize_by(product_variant: product_variant)
  
    if cart_item.persisted?
      cart_item.quantity += quantity
    else
      cart_item.quantity = quantity
    end
  
    # Ensure cart_item is associated with the customer
    cart_item.customer = current_user.customer
    # success if .save, else error
    if cart_item.save
      flash[:notice] = "Item added to cart."
    else
      flash[:alert] = "Unable to add item to cart."
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
