class AddProvinceIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :province, null: false, foreign_key: true
  end
end
