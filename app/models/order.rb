class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :voucher, optional: true
  has_many :order_items, dependent: :destroy

  enum status: { paid: 0, delivered: 1, in_transit: 2 }
end
