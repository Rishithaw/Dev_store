require "ostruct"

class CartController < ApplicationController

  def show
    session[:cart] ||= {}
    @cart_items = session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      OpenStruct.new(product: product, quantity: quantity, total_price: quantity * product.price)
    end
    @cart_total = @cart_items.sum(&:total_price)
  end

  def add
    session[:cart] ||= {}
    product_id = params[:id].to_s

    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1

    redirect_to cart_path, notice: "Added to cart!"
  end

  def remove
    session[:cart].delete(params[:id].to_s)
    redirect_to cart_path, notice: "Item removed."
  end

  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: "Cart cleared!"
  end

  def increase
    session[:cart] ||= {}
    product_id = params[:id].to_s

    if session[:cart][product_id]
      session[:cart][product_id] += 1
    end

    redirect_to cart_path
  end

  def decrease
    session[:cart] ||= {}
    product_id = params[:id].to_s

    if session[:cart][product_id]
      session[:cart][product_id] -= 1
      session[:cart].delete(product_id) if session[:cart][product_id] <= 0
    end

    redirect_to cart_path
  end

end
