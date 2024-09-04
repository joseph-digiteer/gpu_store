class Customers::CartsController < ApplicationController
  #run set_cart first before any action in the lowest part / private
  before_action :set_cart

  #GET Customer/carts show.html.slim
  #@cart_items:  view to display the items in the cart.
  #@cart.cart_items: This retrieves all CartItem records associated with the current @cart.
  #.includes(:product_variant): This is an optimization to load associated ProductVariant records along with CartItem records. 
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
        #chat gpt flash similar to notice, success
        flash[:notice] = 'Item added to cart!'
      else
        #if stock not enough
        flash[:alert] = 'Not enough stock available.'
      end
    else
      #quantity max = stock max
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
      status: :pending, # always pending check enum in model/order.rb
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
          #check stock 
          redirect_to customers_cart_path, alert: 'Insufficient stock for one or more items.'
          return
        end
      end
  
      @cart.cart_items.destroy_all
      
      # success message if order is created
      redirect_to customers_order_path(@order), notice: 'Order successfully created.'
    else
      # error check  def checkout
      render :show, alert: 'There was an issue with your checkout.'
    end
  end
  

  private
  #always set cart to the current_user.cart (for testing customer side.)
  def set_cart
    @cart = current_user.cart 
  end
end
