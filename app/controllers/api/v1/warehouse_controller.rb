require "errors/api_errors"
class Api::V1::WarehouseController < ApplicationController
  before_action :authenticate_user!

  def index
    warehouse = Warehouse.all

    raise ApiError.new(I18n.t("errors.msgs.not_found"), 404) if warehouse.nil?

    render json: { :success => true, :data => warehouse }, :status => 200
  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end
end