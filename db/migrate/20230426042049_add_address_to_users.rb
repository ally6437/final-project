class AddAddressToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :address, :string
    add_column :users, :province_id, :integer
    add_foreign_key :users, :provinces
  end
end
