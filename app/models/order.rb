class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  belongs_to :shipping_province, class_name: "Province", foreign_key: "shipping_province_id"
  has_many :order_items, dependent: :destroy

  STATUSES = %w[pending paid shipped completed].freeze

  validates :user_id, :province_id, :shipping_province_id, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :subtotal, :gst, :pst, :hst, :total,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :shipping_street, :shipping_city, presence: true
  validates :shipping_postal_code,
            presence: true,
            format: { with: /\A[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d\z/ }
  validates :payment_reference, presence: true

  before_save :calculate_totals

  def calculate_totals
    self.subtotal = order_items.sum(&:line_total)

    if shipping_province.present?
      self.gst = subtotal * (shipping_province.gst || 0)
      self.pst = subtotal * (shipping_province.pst || 0)
      self.hst = subtotal * (shipping_province.hst || 0)
    else
      self.gst = self.pst = self.hst = 0
    end

    self.total = subtotal + gst + pst + hst
  end
end
