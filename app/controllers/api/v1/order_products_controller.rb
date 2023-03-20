require "errors/api_errors"
class Api::V1::OrderProductsController < ApplicationController
  before_action :authenticate_user!

  def create
    order_product = OrderProduct.new(permit_params)

    order = Order.find_by(id: order_product.order_id)
    product = Product.find_by(id: order_product.product_id)

    raise ApiError.new(I18n.t("errors.msgs.not_found"), 404) if order.nil? || product.nil? || order_product.serial_number.nil? || order_product.model_number.nil?

    raise ApiError.new(I18n.t("errors.msgs.unable_to_updated_product"), 401) if order.status != "created"

    if order_product.save
      response = order_product.as_json
      response[:product] = order_product.product.as_json
      response[:product][:supplier] = order_product.product.supplier

      response.delete("product_id")
      response[:product].delete("supplier_id")

      render json: { :success => true, :data => response }, :status => 201
    else
      raise ApiError.new(I18n.t("errors.msgs.unprocessable_entity"), 501) if order.nil? || product.nil? || order_product.serial_number.nil? || order_product.model_number.nil?
    end

  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end

  def update
    order_product = OrderProduct.includes(:order).find(params[:id])
    saved = order_product.update(update_permit_params)

    raise ApiError.new(I18n.t("errors.msgs.unable_to_updated_product"), 401) if order_product.order.status != "created"

    if !saved.nil?
      response = order_product.as_json
      response[:product] = order_product.product.as_json
      response[:product][:supplier] = order_product.product.supplier

      response.delete("product_id")
      response[:product].delete("supplier_id")
      
      render json: { :success => true, :data => response }, :status => 200
    else
      raise ApiError.new(I18n.t("errors.msgs.unprocessable_entity"), 501)
    end

  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end

  def destroy
    order_product = OrderProduct.includes(:order).find(params[:id])

    if order_product.order.sent_from_user_id == current_user.id && order_product.destroy
      render json: { :success => true, :message => 'Deleted Successfully' }, :status => 200
    else
      raise ApiError.new(I18n.t("errors.msgs.unprocessable_entity"), 501)
    end

  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end

  def show
  end

  def index
    order = Order.includes(:order_products).find_by(id: params[:order_id])

    raise ApiError.new(I18n.t("errors.msgs.not_found"), 404) if order.nil?

    response = order.order_products.map do |product|
      product_hash = product.as_json

      product_hash[:product] = product.product.as_json
      product_hash[:product][:supplier] = product.product.supplier

      product_hash.delete("product_id")
      product_hash[:product].delete("supplier_id")

      product_hash
    end

    render json: { :success => true, :data => response }, :status => 200
  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status    
  end

  private

  def permit_params
    params.require(:order_product).permit(:order_id, :product_id, :serial_number, :model_number, :quantity, :unit)
  end

  def update_permit_params
    params.require(:order_product).permit(:product_id, :serial_number, :model_number, :quantity, :unit)
  end
end