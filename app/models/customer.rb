class Customer < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy
  has_many :cart_items, dependent: :destroy
end
