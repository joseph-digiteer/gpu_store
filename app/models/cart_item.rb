# app/models/cart_item.rb
class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product_variant
  belongs_to :customer  # Ensure this is correctly defined

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
