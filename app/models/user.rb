# app/models/user.rb
class User < ApplicationRecord
  has_one :customer, dependent: :destroy
  has_one :cart, dependent: :destroy  # Updated association to match the single cart per user
  enum role: { customer: 0, admin: 1 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_cart  # Callback to ensure cart is created for new users

  private

  def create_cart
    Cart.create(user: self) unless cart
  end
end
