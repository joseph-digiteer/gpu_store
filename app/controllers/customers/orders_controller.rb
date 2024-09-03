class Customers::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @orders = current_user.customer.orders
  end
  def show
    @order = current_user.customer.orders.find(params[:id])
    @customer = current_user.customer 
  end

  def new
    @order = Order.new
    @order_items = current_cart.items # Assuming you have a current_cart method
  end

  def create
    @order = current_customer.orders.new(order_params)
    @order.total_amount = calculate_total(@order.order_items)
    
    # Apply voucher if provided
    if params[:voucher_code].present?
      voucher = Voucher.find_by(code: params[:voucher_code])
      if voucher && voucher.valid_for?(@order.total_amount)
        @order.apply_voucher(voucher)
      else
        flash[:alert] = "Invalid or inapplicable voucher"
        render :new and return
      end
    end

    if @order.save && current_customer.sufficient_balance?(@order.total_amount)
      current_customer.deduct_balance!(@order.total_amount)
      update_stock(@order.order_items)
      clear_cart # Clear the cart after successful checkout
      redirect_to order_path(@order), notice: "Order successfully placed!"
    else
      flash[:alert] = "Insufficient balance" unless current_customer.sufficient_balance?(@order.total_amount)
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(order_items_attributes: [:product_variant_id, :quantity])
  end

  def calculate_total(order_items)
    order_items.sum { |item| item.quantity * item.product_variant.price }
  end

  def update_stock(order_items)
    order_items.each do |item|
      variant = item.product_variant
      variant.update!(stock: variant.stock - item.quantity)
    end
  end
end
