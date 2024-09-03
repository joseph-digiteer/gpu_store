class Customer < ApplicationRecord
  belongs_to :user
  has_one :user
  has_many :cart_items
  has_many :carts
  has_many :orders

  def sufficient_balance?(amount)
    self.balance >= amount
  end

  # Deduct the amount from the customer's balance
  def deduct_balance!(amount)
    update!(balance: self.balance - amount)
  end
  
end
