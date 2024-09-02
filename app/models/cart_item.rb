class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :cart
  belongs_to :product_variant
end
