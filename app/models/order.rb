class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :voucher, optional: true
  has_many :order_items, dependent: :destroy

  enum status: { pending: 0, completed: 1, canceled: 2 }

  validates :total_amount, presence: true
  validates :status, presence: true
end
