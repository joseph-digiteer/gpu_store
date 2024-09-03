class Customer < ApplicationRecord
  has_one :user
  has_many :cart_items
  has_many :carts
end
