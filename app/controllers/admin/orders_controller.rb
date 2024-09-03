class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /admin/orders
  def index
    @orders = Order.all
  end

  # GET /admin/orders/1
  def show
  end

  # GET /admin/orders/new
  def new
    @order = Order.new
  end

  # POST /admin/orders
  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to admin_order_path(@order), notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  # GET /admin/orders/1/edit
  def edit
  end

  # PATCH/PUT /admin/orders/1
  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/orders/1
  def destroy
    @order.destroy
    redirect_to admin_orders_path, notice: 'Order was successfully destroyed.'
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:customer_id, :total_amount, :status, :voucher_id)
  end
end
