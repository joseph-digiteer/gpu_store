class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :phone_number
      t.decimal :balance
      t.boolean :active

      t.timestamps
    end
  end
end
