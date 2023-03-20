require "errors/api_errors"
class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user!

  # GET /order
  def index
    return if !user_exist?
  
    type = params[:type]
    limit = params[:limit] ? params[:limit].to_i : 10
    offset = params[:offset] ? params[:offset].to_i : 0

    response_orders = nil
    show_columns = exclude_columns(["updated_at"])
    or_columns = {}
    
    and_columns = {}
    and_columns[:status] = Order.statuses[params[:status].to_sym] if params[:status].present?

    if type == "sent"
      or_columns["sent_from_user_id"] = current_user.id
    elsif type == "recieved"
      or_columns["sent_to_user_id"] = current_user.id
    else
      or_columns["sent_from_user_id"] = current_user.id
      or_columns["sent_to_user_id"] = current_user.id
    end

    response_orders = fetch_orders(or_columns, and_columns, show_columns, limit, offset)

    response = response_orders.map do |order|
      parse_order_response(order)
    end

    render json: { :success => true, :data => response }, :status => 200
  end

  # POST /order
  def create
    order = Order.new(permit_params)

    if order.order_type.to_sym == :purchase # supplier ===> warehouse
      order_purchase(order)
    elsif order.order_type.to_sym == :stock_transfer # warehouse x ===> warehouse y
      order_stock_transfer(order)
    elsif order.order_type.to_sym == :installation # warehouse ===> site engineer
      order_installation(order)
    end

    # if !order.parent_order_id.nil?
    #   parent_order = Order.find(order.parent_order_id)

    #   if parent_order.nil?
    #     render json: { :success => false, :message => "Parent order does not exists" }, :status => 404
    #     return
    #   end

    #   order.sent_to_user_id = parent_order.sent_from_user_id
    # end

    # if order.sent_from_user_id == order.sent_to_user_id
    #   raise ApiError.new("Cannot return order to yourself!", 401)
    #   return
    # end

    if order.save
      render json: { :success => true, :data => order }, :status => 201
    else
      raise ApiError.new(I18n.t("errors.msgs.unprocessable_entity"), 501)
    end

  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end

  # PUT /order/:id
  def update
    order = Order.find_by(id: params[:id])

    raise ApiError.new(I18n.t("errors.msgs.order_info_incomplete"), 422) if order.nil? || params[:order][:status].nil?

    order_status = params[:order][:status].to_sym

    if order.status != order_status
      if order_status == :sent
        order.sent_at = Time.now
      elsif order_status == :recieved
        order.recieved_at = Time.now
      end
    end

    params[:order].each do |key, value|
      order[key] = value
    end

    if order_status == :purchase
      order_purchase(order)
    elsif order_status == :stock_transfer
      order_stock_transfer(order)
    elsif order_status == :installation
      order_installation(order)
    end

    # if (order_status > 1 && order.sent_from_user_id == current_user.id) || (order.sent_to_user_id == current_user.id && order_status <= 1)
    #   render json: { :success => false, :message => "You are not authorized!" }, :status => 401
    #   return
    # end

    if order.save
      order = parse_order_response(order)
      render json: { :success => true, :data => order }, :status => 200
    else
      raise ApiError.new(I18n.t("errors.msgs.unable_to_update"), 501)
    end
  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end

  # GET /order/:id
  def show
    order = Order.find_by(id: params[:id])

    raise ApiError.new(I18n.t("errors.msgs.not_found"), 404) if order.nil?

    response = parse_order_response(order)

    # response = {
    #   :order => order,
    #   :order_products => order.order_products,
    #   :return_order => order.child,
    # }

    render json: { :success => true, :data => response }, :status => 200
  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end

  private

  def user_exist?
    user = User.find(current_user.id)

    if user.nil?
      render json: { :success => false, :message => "No user found!" }, :status => 404
      return false
    end

    return true;
  end

  def exclude_columns col_names
    return Order.column_names if col_names.length == 0

    return Order.column_names - col_names
  end

  def fetch_orders or_columns, and_columns, show_columns, limit, offset
    or_conditions = or_columns.map { |column, value| "#{column} = ?" }.join(" OR ")
    or_conditions = "(#{or_conditions})"

    and_conditions_array = and_columns.map { |column, value| "#{column} = ?" }.join(" AND ")

    conditions = [or_conditions]

    if and_conditions_array.present?
      and_conditions_array = "(#{and_conditions_array})"
      conditions.concat([and_conditions_array])
    end
    conditions = conditions.join(" AND ")

    values = or_columns.values + and_columns.values

    Order.includes(:sent_from_user, :sent_to_user, :issued_to_warehouse).where(conditions, *values).select(show_columns).limit(limit).offset(offset * limit)
  end

  def order_purchase(order)
    order.sent_to_user_id = current_user.id
    order.status = :created
    order.transfer_type = :in
    order.issued_to_warehouse_id = current_user.warehouse_id
    supplier_user = User.find_by(id: order.sent_from_user_id)

    raise ApiError.new(I18n.t("errors.msgs.supplier_user_unset"), 422) if supplier_user.nil? || supplier_user.user_type.role != "supplier"

    raise ApiError.new(I18n.t("errors.msgs.warehouse_user_unset"), 422) if current_user.warehouse_id.nil?

    order.sent_at = nil
    order.recieved_at = nil    
  end

  def order_stock_transfer(order)
    order.sent_from_user_id = current_user.id
    order.status = :created
    order.transfer_type = :out

    raise ApiError.new(I18n.t("errors.msgs.warehouse_unset")) if order.issued_to_warehouse_id.nil?

    raise ApiError.new(I18n.t("errors.msgs.warehouse_user_unset")) if current_user.warehouse_id.nil?

    order.sent_at = nil
    order.recieved_at = nil
  end

  def order_installation(order)
    order.sent_from_user_id = current_user.id
    order.status = :created
    order.transfer_type = :out

    site_engineer_user = User.find_by(id: order.sent_to_user_id)

    raise ApiError.new(I18n.t("errors.msgs.site_engineer_unset")) if site_engineer_user.nil? || site_engineer_user.user_type.role != "site_engineer"

    raise ApiError.new(I18n.t("errors.msgs.warehouse_user_unset")) if current_user.warehouse_id.nil?

    order.sent_at = nil
    order.recieved_at = nil    
  end

  def permit_params
    params.require(:order).permit(:sent_from_user_id, :sent_to_user_id, :parent_order_id, :status, :transfer_typed, :order_type, :payment_mode, :issued_to_warehouse_id, :issued_for_client_name, :issued_for_client_address, :issued_for_client_pincode, :service_report_number, :delievery_challan_number, :sent_at, :recieved_at)
  end

  def parse_order_response order
    order_hash = order.as_json

    order_hash[:sent_from_user] = order.sent_from_user.as_json
    if !order.sent_from_user.nil?
      order_hash[:sent_from_user][:warehouse] = order.sent_from_user.warehouse
      order_hash[:sent_from_user][:user_type] = order.sent_from_user.user_type.role
    end

    order_hash[:sent_to_user] = order.sent_to_user.as_json
    if !order.sent_to_user.nil?
      order_hash[:sent_to_user][:warehouse] = order.sent_to_user.warehouse if order.sent_to_user
      order_hash[:sent_to_user][:user_type] = order.sent_to_user.user_type.role  
    end

    order_hash[:issued_to_warehouse] = order.issued_to_warehouse.as_json

    # remove keys
    order_hash.delete("sent_from_user_id")
    order_hash.delete("sent_to_user_id")
    order_hash.delete("issued_to_warehouse_id")
    if !order_hash[:sent_from_user].nil?
      order_hash[:sent_from_user].delete("user_type_id")
      order_hash[:sent_from_user].delete("warehouse_id")  
    end

    if !order_hash[:sent_to_user].nil?
      order_hash[:sent_to_user].delete("user_type_id")
      order_hash[:sent_to_user].delete("warehouse_id")  
    end

    order_hash
  end
end