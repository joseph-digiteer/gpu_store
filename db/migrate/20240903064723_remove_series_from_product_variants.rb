class RemoveSeriesFromProductVariants < ActiveRecord::Migration[7.1]
  def change
    remove_column :product_variants, :series, :string
  end
end
