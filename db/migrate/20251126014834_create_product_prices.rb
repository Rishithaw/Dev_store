class CreateProductPrices < ActiveRecord::Migration[8.0]
  def change
    create_table :product_prices do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :price
      t.date :effective_date

      t.timestamps
    end
  end
end
