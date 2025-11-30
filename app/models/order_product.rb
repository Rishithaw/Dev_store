class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :product_price_at_purchase,
            numericality: { greater_than_or_equal_to: 0 }

  # Automatically set fields based on product data
  before_validation :set_purchase_details
  before_save :calculate_line_total

  private

  def set_purchase_details
    if product.present?
      self.product_price_at_purchase ||= product.price
      self.product_name_at_purchase ||= product.name
    end
  end

  def calculate_line_total
    self.line_total = product_price_at_purchase * quantity
  end
end
