class ChangeVoucherIdToAllowNullInOrders < ActiveRecord::Migration[7.1]
  def change
    change_column_null :orders, :voucher_id, true
  end
end
