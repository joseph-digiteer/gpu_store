module ApplicationHelper
  include Pagy::Frontend
  def cart_items_count
    current_cart.present? ? current_cart.cart_items.count : 0
  end
end
