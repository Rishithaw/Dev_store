class CartController < ApplicationController
  before_action :initialize_cart

  def index
    @cart_items = Product.where(id: @cart.keys)
  end

  def add
    product_id = params[:product_id].to_s
    @cart[product_id] ||= 0
    @cart[product_id] += 1
    session[:cart] = @cart

    redirect_to cart_index_path, notice: "Added to cart!"
  end

  def remove
    product_id = params[:product_id].to_s
    @cart.delete(product_id)
    session[:cart] = @cart

    redirect_to cart_index_path, notice: "Item removed."
  end

  def clear
    session[:cart] = {}
    redirect_to cart_index_path, notice: "Cart cleared."
  end

  private

  def initialize_cart
    session[:cart] ||= {}
    @cart = session[:cart]
  end
end
