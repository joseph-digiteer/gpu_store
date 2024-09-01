class AddSeriesToProductVariants < ActiveRecord::Migration[7.1]
  def change
    add_column :product_variants, :series, :string
  end
end
