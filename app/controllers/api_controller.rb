# frozen_string_literal: true

class ApiController < ActionController::API
  # Service to download ftp from the
  require 'jwt'
  include JsonWebToken
  before_action :authenticate_request
  def current_user
    @current_user
  end
  rescue_from CanCan::AccessDenied do |exception|
    render json: {warning: exception, status: 'authorization_failed'}
  end
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {warning: exception, status: '404'}
  end
  rescue_from NoMethodError do |exception|
    render json: {warning: exception, status: '500'}
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = decode(header)
    @current_user = User.find(decoded[:user_id])
  rescue StandardError
    render json: { error: 'Unauthorized User' }, status: 400
  end
end
