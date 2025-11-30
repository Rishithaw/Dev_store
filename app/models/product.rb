class Product < ApplicationRecord
  has_one_attached :image
  belongs_to :category

  def self.ransackable_attributes(auth_object = nil)
    [
      "name", "description", "base_price", "category_id",
      "stock_quantity", "product_type", "on_sale", "sale_price",
      "featured", "digital_file_url", "digital_file_size",
      "created_at", "updated_at", "id"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end
  def price
    on_sale? && sale_price.present? ? sale_price : base_price
  end
end
