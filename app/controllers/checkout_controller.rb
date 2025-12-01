class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart

  def show
    # Reminder, come back to this
  end

  def address
    @address = current_user.addresses.find_by(is_default: true) || Address.new
    @provinces = Province.all
  end

  def save_address
    @address = current_user.addresses.find_or_initialize_by(is_default: true)
    @address.assign_attributes(address_params)

    if @address.save
      redirect_to confirm_checkout_path, notice: "Address saved successfully."
    else
      @provinces = Province.all
      flash.now[:alert] = "Please fix the errors below."
      render :address
    end
  end

  def confirm
    @address = current_user.addresses.find_by(is_default: true)

    province = @address.province

    @subtotal = @cart_items.sum { |p| p.price * session[:cart][p.id.to_s] }
    @gst = @subtotal * (province.gst || 0)
    @pst = @subtotal * (province.pst || 0)
    @hst = @subtotal * (province.hst || 0)
    @total = @subtotal + @gst + @pst + @hst
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
        shipping_postal_code: address.postal_code
      )

      session[:cart].each do |product_id, quantity|
        product = Product.find(product_id)

        order.order_items.create!(
          product: product,
          quantity: quantity,
          product_price_at_purchase: product.price,
          product_name_at_purchase: product.name
        )
      end
    end

    session[:cart] = {}

    redirect_to root_path, notice: "Order completed! Your invoice has been emailed."
  end

  private

  def load_cart
    @cart = session[:cart] || {}
    @cart_items = Product.where(id: @cart.keys)
  end

  def address_params
    params.require(:address).permit(:street, :city, :postal_code, :province_id)
  end
end
