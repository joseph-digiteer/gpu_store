class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :product_variants
  accepts_nested_attributes_for :product_variants, allow_destroy: true

  # Allow list attributes that can be searched using Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "description", "id", "name", "updated_at"]
  end

  # Allow list associations that can be searched using Ransack
  def self.ransackable_associations(auth_object = nil)
    ["product_variants"] # Add any associations you want to be searchable
  end
end
