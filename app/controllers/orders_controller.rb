class OrdersController < ApplicationController
  # Devise helper — ensures only logged-in customers can create/view orders
  before_action :authenticate_customer!

  # Ensure customer can only access THEIR orders
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authorize_order!, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # Shows all orders for the currently logged-in customer
  def index
    @orders = current_customer.orders.order(created_at: :desc)
  end

  # GET /orders/:id
  def show
  end

  # GET /orders/new
  def new
    @order = current_customer.orders.build
  end

  # POST /orders
  def create
    @order = current_customer.orders.build(order_params)

    if @order.save
      redirect_to @order, notice: "Order was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /orders/:id/edit
  def edit
  end

  # PATCH/PUT /orders/:id
  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Order updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /orders/:id
  def destroy
    @order.destroy
    redirect_to orders_path, notice: "Order deleted."
  end

  private

  # Finds the order
  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "Order not found."
  end

  # Ensures the order belongs to the logged-in customer
  def authorize_order!
    unless @order.customer_id == current_customer.id
      redirect_to orders_path, alert: "You are not authorized to access this order."
    end
  end

  # Strong params
  def order_params
    params.require(:order).permit(
      :total_price,
      :status,
      :shipping_address,
      :billing_address,
      # Add other fields based on your schema
    )
  end
end
