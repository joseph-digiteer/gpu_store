class Customer < ApplicationRecord
  belongs_to :user
  has_one :cart
  has_many :orders
  has_many :cart_items

  def sufficient_balance?(amount)
    self.balance >= amount
  end

  # Deduct the amount from the customer's balance
  def deduct_balance!(amount)
    update!(balance: self.balance - amount)
  end
  
end
