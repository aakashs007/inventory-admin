class Api::V1::OrderProductsController < ApplicationController
  before_action :authenticate_user!

  def create
    order_product = OrderProduct.new(permit_params)

    order = Order.find_by(id: order_product.order_id)
    product = Product.find_by(id: order_product.product_id)

    if order.nil? || product.nil? || order_product.serial_number.nil?
      render json: { :success => false, :message => "Invalid request!" }, :status => 404
      return
    end


    if order_product.save
      render json: { :success => true, :data => order_product }, :status => 201
    else
      render json: { :success => false, :message => "Internal server error!" }, :status => 501
    end
  end

  def update
  end

  def show
  end

  def destroy
  end

  private

  def permit_params
    params.require(:order_product).permit(:order_id, :product_id, :serial_number)
  end
end