class HomeController < ApplicationController
  def index
  end
  def cart_items_count
    current_cart.present? ? current_cart.items.count : 0
  end
end
