class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true
      t.string :status
      t.decimal :subtotal
      t.decimal :gst
      t.decimal :pst
      t.decimal :hst
      t.decimal :total
      t.string :payment_reference
      t.string :shipping_street
      t.string :shipping_city
      t.string :shipping_postal_code

      t.timestamps
    end
  end
end
