class Product < ApplicationRecord
  has_one_attached :image
  belongs_to :category

  validates :name, presence: true
  validates :description, presence: true

  validates :base_price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :stock_quantity,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :product_type, presence: true

  validates :on_sale, inclusion: { in: [true, false] }
  validates :featured, inclusion: { in: [true, false] }

  validates :sale_price,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validates :digital_file_size,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validates :digital_file_url, presence: true, if: -> { product_type == "digital" }

  scope :on_sale, -> { where("sale_price IS NOT NULL AND sale_price < price") }

  scope :new_products, -> { where("created_at >= ?", 3.days.ago) }

  scope :recently_updated, -> {
    where("updated_at >= ?", 3.days.ago)
      .where.not(id: new_products.select(:id))
}

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
