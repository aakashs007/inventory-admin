require "errors/api_errors"
class Api::V1::StocksController < ApplicationController
  before_action :authenticate_user!

  def index
    user = User.includes(:warehouse).find(current_user.id)

    raise ApiError.new(I18n.t("errors.msgs.not_found"), 404) if user.nil?

    stocks = Stock.includes(:warehouse).where(warehouse_id: user.warehouse.id)

    response = stocks.map do |stock|
      stock_hash = stock.as_json
      stock_hash[:warehouse] = stock.warehouse

      stock_hash.delete("warehouse_id")

      stock_hash
    end

    render json: { :success => true, :data => response }, :status => 200
  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end

  def update
  end
end