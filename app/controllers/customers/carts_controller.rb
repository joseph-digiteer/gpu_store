class Customers::CartsController < ApplicationController
  before_action :set_cart

  def show
    # Show cart details
  end

  private

  def set_cart
    @cart_item_count = current_user.cart.items.count # Adjust this based on your cart implementation
  end
end
