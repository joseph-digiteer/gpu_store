class Customers::ProductsController < ApplicationController
  include Pagy::Backend

  #before_action :authorize_customer

  #index main page -> @q = stored data, product = product model, ransack = create search form, params[:q] = throw back the value 
  #basically what you put inside of the search bar
  def index
    @q = Product.ransack(params[:q])
    #limit 15 series per page
    @pagy, @products = pagy(@q.result.includes(:product_variants).where(active: true), items: 15)
  end

  #shwo product -> product ID ex. GTX Series -> GTX Variants (ID ex = 1050ti)
  def show
    @product = Product.find(params[:id])
    @variants = @product.product_variants.where(active: true)
  end

  private

  #def authorize_customer
    #redirect_to(root_path, alert: 'Not authorized') unless current_user.customer?
  #end
end
