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
    @cart = current_user.cart
    unless @cart
      Rails.logger.error("Cart not found for user #{current_user.id}")
      redirect_to customers_cart_path, alert: 'Your cart is empty or cannot be found.'
      return
    end
  
    customer = current_user.customer
    Rails.logger.info("Customer found: #{customer.inspect}")
  
    voucher = Voucher.find_by(code: params[:voucher_code]) if params[:voucher_code].present?
    Rails.logger.info("Voucher found: #{voucher.inspect}")
  
    total_amount = @cart.total_amount
    Rails.logger.info("Total amount before voucher discount: #{total_amount}")
  
    if voucher && total_amount >= voucher.minimum_spend
      discount_amount = voucher.amount
      total_amount -= discount_amount
    else
      discount_amount = 0
    end
  
    Rails.logger.info("Total amount after voucher discount: #{total_amount}")
  
    if customer.balance < total_amount
      Rails.logger.error("Insufficient balance. Customer balance: #{customer.balance}, Total amount: #{total_amount}")
      redirect_to cart_path, alert: 'Insufficient balance for checkout.'
      return
    end
  
    ActiveRecord::Base.transaction do
      order_params = {
        customer_id: customer.id,
        total_amount: total_amount,
        status: :pending,
        voucher_id: voucher&.id
      }
  
      @order = Order.new(order_params)
  
      if @order.save
        Rails.logger.info("Order created successfully: #{@order.inspect}")
  
        @cart.cart_items.each do |item|
          @order.order_items.create!(
            product_variant_id: item.product_variant_id,
            quantity: item.quantity
          )
  
          product_variant = item.product_variant
          if product_variant.stock >= item.quantity
            product_variant.update!(stock: product_variant.stock - item.quantity)
          else
            Rails.logger.error("Insufficient stock for product_variant ID #{product_variant.id}")
            raise ActiveRecord::Rollback, 'Insufficient stock for one or more items.'
          end
        end
  
        @cart.cart_items.destroy_all
  
        # Deduct balance from the customer
        customer.update!(balance: customer.balance - total_amount)
        Rails.logger.info("Balance updated successfully: #{customer.balance}")
  
        redirect_to customers_order_path(@order), notice: 'Order successfully created.'
      else
        Rails.logger.error("Order could not be saved: #{@order.errors.full_messages}")
        raise ActiveRecord::Rollback, 'There was an issue with your order.'
      end
    end
  rescue ActiveRecord::Rollback => e
    Rails.logger.error("Checkout failed: #{e.message}")
    redirect_to cart_path, alert: 'There was an issue with your checkout.'
  end
  
  
  private
  #always set cart to the current_user.cart (for testing customer side.)
  def set_cart
    @cart = current_user.cart
    if @cart.nil?
      Rails.logger.error("No cart associated with user #{current_user.id}")
      redirect_to customers_cart_path, alert: 'No cart found.'
    end
  end  
end
