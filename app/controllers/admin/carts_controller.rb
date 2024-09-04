class Admin::CartsController < ApplicationController
  before_action :authenticate_admin!  # Ensure only admins can access
  before_action :set_cart, only: [:show, :edit, :update, :destroy]  # Use before_action to set @cart

  def index
    @carts = Cart.includes(:customer).all
  end

  def show
    @cart_items = @cart.cart_items.includes(:product_variant)
  end

  def edit
    # @cart is set by before_action :set_cart
  end

  def update
    # Updating cart items directly
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to admin_cart_path(@cart_item.cart), notice: 'Cart item updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to admin_cart_path(@cart_item.cart), notice: 'Cart item removed successfully.'
  end

  private

  def set_cart
    @cart = Cart.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_carts_path, alert: 'Cart not found.'
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end

  def authenticate_admin!
    redirect_to root_path, alert: 'Not authorized' unless current_user.admin?
  end
end
