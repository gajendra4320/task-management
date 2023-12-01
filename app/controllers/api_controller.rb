# frozen_string_literal: true

class ApiController < ActionController::API
  # Service to download ftp from the
  require 'jwt'
  include JsonWebToken
  before_action :authenticate_request
  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = decode(header)
    @current_user = User.find(decoded[:user_id])
  rescue StandardError
    render json: { error: 'Unauthorized User' }, status: 400
  end

  # def check_user
  #   render json: { error: 'Not Allowed' } unless @current_user.user_type == 'Admin'
  # end
end
