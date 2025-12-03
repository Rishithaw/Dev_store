class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart
  before_action :load_cart_items
  before_action :ensure_cart_not_empty

  def address
    @address = current_user.addresses.find_by(is_default: true) ||
               current_user.addresses.build

    @provinces = Province.all
  end

  def save_address
    @address = current_user.addresses.find_by(is_default: true) ||
               current_user.addresses.build

    @address.is_default = true

    if @address.update(address_params)
      redirect_to review_checkout_path, notice: "Address saved successfully!"
    else
      @provinces = Province.all
      render :address, status: :unprocessable_entity
    end
  end

  def review
    @address = current_user.addresses.find_by(is_default: true)
    @cart_items = @cart_items # already loaded
  end

  def confirm
    @address = current_user.addresses.find_by(is_default: true)
    province = @address.province

    @subtotal = @cart_items.sum { |p| p.price * @cart[p.id.to_s] }
    @gst      = @subtotal * (province.gst || 0)
    @pst      = @subtotal * (province.pst || 0)
    @hst      = @subtotal * (province.hst || 0)

    @total    = @subtotal + @gst + @pst + @hst
  end

  def complete
    ActiveRecord::Base.transaction do
      address = current_user.addresses.find_by(is_default: true)
      province = address.province

      order = current_user.orders.create!(
        status: "pending",
        province: province,
        shipping_province: province,
        shipping_street: address.street,
        shipping_city: address.city,
        shipping_postal_code: address.postal_code,
        payment_reference: "PAY-#{SecureRandom.hex(5)}"
      )

      @cart.each do |product_id, qty|
        product = Product.find(product_id)

        order.order_items.create!(
          product: product,
          quantity: qty,
          product_price_at_purchase: product.price,
          product_name_at_purchase: product.name
        )
      end

      session[:cart] = {}
      @last_order = order
    end

    render :complete
  end

  private

  def load_cart
    @cart = current_cart
  end

  def load_cart_items
    @cart_items = Product.where(id: @cart.keys)
  end

  def ensure_cart_not_empty
    if @cart.blank?
      redirect_to products_path, alert: "Your cart is empty."
    end
  end

  def address_params
    params.require(:address).permit(:street, :city, :postal_code, :province_id)
  end
end
