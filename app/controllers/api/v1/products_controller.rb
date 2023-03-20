require "errors/api_errors"

class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    products =  Product.where(active: true).select(:id, :name, :price, :vat)

    raise ApiError.new(I18n.t("errors.msgs.not_found"), 404) if products.nil?

    render json: { :success => true, :data => products }, :status => 200
  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end
end