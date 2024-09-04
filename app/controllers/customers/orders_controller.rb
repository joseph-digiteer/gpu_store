class Customers::OrdersController < ApplicationController
  before_action :authenticate_customer!

  #current user -> customer -> and what is his/her orders
  def index
    @orders = current_user.customer.orders
  end
  #show.html.slim, basically in url, it will show what id of the order for example orders/3 = 3 is the ID
  def show
    @order = current_user.customer.orders.find(params[:id])
    @customer = current_user.customer 
  end

  #basically creating a new of items inside of the cart
  def new
    @order = Order.new
    @order_items = current_cart.items # Assuming you have a current_cart method
  end
  #call create, for you to create order. 
  def create
    @order = current_customer.orders.new(order_params)
    @order.total_amount = calculate_total(@order.order_items)
    
    # Apply voucher if provided if not then throw an error or voucher not applied
    if params[:voucher_code].present?
      voucher = Voucher.find_by(code: params[:voucher_code])
      if voucher && voucher.valid_for?(@order.total_amount)
        @order.apply_voucher(voucher)
      else
        flash[:alert] = "Invalid or inapplicable voucher"
        render :new and return
      end
    end
    #upon saving the order, clear the cart because its now transferred to order
    if @order.save && current_customer.sufficient_balance?(@order.total_amount)
      current_customer.deduct_balance!(@order.total_amount)
      update_stock(@order.order_items)
      clear_cart # Clear the cart after successful checkout
      redirect_to order_path(@order), notice: "Order successfully placed!"
    else
      #balance check if money - total amount
      flash[:alert] = "Insufficient balance" unless current_customer.sufficient_balance?(@order.total_amount)
      render :new
    end
  end

  private

  #di ko gets send help Sir Raph
  #params is like a big bag that holds all the data sent to your server.
  #require(:order) checks if there is a key called :order in this bag. If it’s missing, an error occurs.
  #permit(order_items_attributes: [:product_variant_id, :quantity]) says, “From the #:order data, only allow these specific pieces of information (in this case, :product_variant_id and :quantity) to be used.”
  def order_params
    params.require(:order).permit(order_items_attributes: [:product_variant_id, :quantity])
  end

  #basic math sum of all product.order (1pc item = 5499, so if PCs x price = amount)
  def calculate_total(order_items)
    order_items.sum { |item| item.quantity * item.product_variant.price }
  end

  #deduct stock once u order
  def update_stock(order_items)
    order_items.each do |item|
      variant = item.product_variant
      variant.update!(stock: variant.stock - item.quantity)
    end
  end
end
