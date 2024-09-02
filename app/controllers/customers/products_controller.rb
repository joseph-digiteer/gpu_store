class Customers::ProductsController < ApplicationController
  include Pagy::Backend

  #before_action :authorize_customer

  def index
    @q = Product.ransack(params[:q])
    @pagy, @products = pagy(@q.result.includes(:product_variants).where(active: true), items: 15)
  end

  def show
    @product = Product.find(params[:id])
    @variants = @product.product_variants.where(active: true)
  end

  private

  #def authorize_customer
    #redirect_to(root_path, alert: 'Not authorized') unless current_user.customer?
  #end
end
