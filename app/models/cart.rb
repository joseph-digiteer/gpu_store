class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :customer
  has_many :cart_items, dependent: :destroy

  def total_amount
    cart_items.includes(:product_variant).sum do |item|
      item.product_variant.price * item.quantity
    end
  end
  
end
