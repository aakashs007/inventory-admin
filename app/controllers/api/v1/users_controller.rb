require "errors/api_errors"
class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.includes(:user_info, :user_type).all

    raise ApiError.new(I18n.t("errors.msgs.not_found"), 404) if users.nil?

    response = users.map do |user|
      {
        id: user.id,
        email: user.email,
        user_type: user.user_type.role,
        first_name: user.user_info ? user.user_info.first_name : "",
        last_name: user.user_info ? user.user_info.last_name : "",
      }
    end

    render json: { :success => true, :data => response }, :status => 200
  rescue ApiError => error
    render json: { :success => false, :message => error.message }, :status => error.status
  end

  private

  def parse_user_response(user)
    user_hash = user.as_json


    user_hash
  end
end