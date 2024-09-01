# app/models/user.rb
class User < ApplicationRecord
  has_one :customer, dependent: :destroy
  enum role: { customer: 0, admin: 1 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Devise modules here
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
