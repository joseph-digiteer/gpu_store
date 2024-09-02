class ApplicationController < ActionController::Base
  helper_method :current_cart

  def current_cart
    if user_signed_in?
      @current_cart ||= Cart.find_by(user_id: current_user.id) || Cart.create(user_id: current_user.id)
    else
      nil
    end
  end
  

  def cart_items_count
    current_cart.present? ? current_cart.cart_items.count : 0
  end
end
