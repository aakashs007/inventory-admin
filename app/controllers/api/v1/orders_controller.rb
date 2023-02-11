class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user!

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

    render json: { :success => true, :data => response_orders }, :status => 200
  end

  def create
    return if !user_exist?

    order = Order.new(permit_params)
    order.sent_from_user_id = current_user.id

    if !order.parent_order_id.nil?
      parent_order = Order.find(order.parent_order_id)

      if parent_order.nil?
        render json: { :success => false, :message => "Parent order does not exists" }, :status => 404
        return
      end

      order.sent_to_user_id = parent_order.sent_from_user_id
    end

    if order.sent_from_user_id == order.sent_to_user_id
      render json: { :success => false, :message => "Cannot return order to yourself!" }, :status => 401
      return
    end

    order.status = 0

    if order.save
      render json: { :success => true, :data => order }, :status => 201
    else
      render json: { :success => false, :message => "Unable to create order!" }, :status => 501
    end
  end

  def update
    order = Order.find(params[:id])

    if order.nil? || params[:order][:status].nil?
      render json: { :success => false, :message => "Order update info not complete!" }, :status => 404
      return
    end

    order_status = Order.statuses[params[:order][:status].to_sym]

    if (order_status > 1 && order.sent_from_user_id == current_user.id) || (order.sent_to_user_id == current_user.id && order_status <= 1)
      render json: { :success => false, :message => "You are not authorized!" }, :status => 401
      return
    end

    order.status = order_status

    if order.save
      render json: { :success => true, :data => order }, :status => 200
    else
      render json: { :success => false, :message => "Error updating error" }, :status => 501
    end
  end

  def show
    order = Order.find_by(id: params[:id])

    if order.nil?
      render json: { :success => false, :message => "Order not exists!" }, :status => 404
      return
    end
  
    response = {
      :order => order,
      :order_products => order.order_products,
      :return_order => order.child,
    }

    render json: { :success => true, :data => response }, :status => 200
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

    Order.where(conditions, *values).select(show_columns).limit(limit).offset(offset * limit)
  end

  def permit_params
    params.require(:order).permit(:sent_to_user_id, :parent_order_id, :status)
  end
end