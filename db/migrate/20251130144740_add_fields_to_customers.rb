class AddFieldsToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_column :customers, :username, :string
    add_column :customers, :address, :string
    add_column :customers, :city, :string
    add_column :customers, :postal_code, :string
  end
end
