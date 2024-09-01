class CreateVouchers < ActiveRecord::Migration[7.1]
  def change
    create_table :vouchers do |t|
      t.string :code
      t.decimal :amount
      t.decimal :minimum_spend
      t.datetime :date_from
      t.datetime :date_to

      t.timestamps
    end
  end
end
