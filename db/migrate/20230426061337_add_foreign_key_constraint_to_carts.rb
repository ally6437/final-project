class AddForeignKeyConstraintToCarts < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :carts, :users
  end
end
