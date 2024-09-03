# app/controllers/customers/carts_controller.rb
class Customers::CartsController < ApplicationController
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product_variant)
  end

  def add_to_cart
    variant_id = params[:product_variant_id]
    quantity = params[:quantity].to_i

    if quantity > 0
      product_variant = ProductVariant.find(variant_id)
      if product_variant && product_variant.stock >= quantity
        cart_item = @cart.cart_items.find_or_initialize_by(product_variant: product_variant)
        # Ensure quantity is initialized to 0 if it's nil
        cart_item.quantity ||= 0
        cart_item.quantity += quantity
        cart_item.save
        flash[:notice] = 'Item added to cart!'
      else
        flash[:alert] = 'Not enough stock available.'
      end
    else
      flash[:alert] = 'Invalid quantity.'
    end

    redirect_to customers_cart_path
  end

  def checkout
    # Find the customer associated with the current user
    customer = current_user.customer
  
    # Check if a voucher code was provided and find the corresponding voucher
    voucher = Voucher.find_by(code: params[:voucher_code]) if params[:voucher_code].present?
  
    # Calculate the total amount and ensure the customer has sufficient balance
    total_amount = @cart.total_amount
  
    # Apply voucher discount if valid
    if voucher && total_amount >= voucher.minimum_spend
      discount_amount = voucher.amount
      total_amount -= discount_amount
    else
      discount_amount = 0
    end
  
    if customer.balance < total_amount
      # Handle insufficient balance
      redirect_to customers_cart_path, alert: 'Insufficient balance for checkout.'
      return
    end
  
    # Create an order with the current cart
    order_params = {
      customer_id: customer.id,
      total_amount: total_amount,
      status: :pending, # Ensure this is a valid status
      voucher_id: voucher&.id # Set to nil if voucher is not present
    }
  
    @order = Order.new(order_params)
  
    if @order.save
      # Deduct the balance
      customer.update(balance: customer.balance - total_amount)
  
      # Process the order and clear the cart
      @cart.cart_items.each do |item|
        # Create order items
        @order.order_items.create!(
          product_variant_id: item.product_variant_id,
          quantity: item.quantity
        )
        
        # Find the product variant and deduct stock
        product_variant = item.product_variant
        if product_variant.stock >= item.quantity
          product_variant.update(stock: product_variant.stock - item.quantity)
        else
          # Handle insufficient stock, possibly rollback
          # Here, you might want to add a mechanism to handle stock discrepancies
          redirect_to customers_cart_path, alert: 'Insufficient stock for one or more items.'
          return
        end
      end
  
      @cart.cart_items.destroy_all
  
      # Redirect or render success message
      redirect_to customers_order_path(@order), notice: 'Order successfully created.'
    else
      # Handle the error case
      render :show, alert: 'There was an issue with your checkout.'
    end
  end
  

  private

  def set_cart
    @cart = current_user.cart 
  end
end
