# frozen_string_literal: true

# Authentication Controller
class AuthenticationController < ApiController
  skip_before_action :authenticate_request
  def login
    @user = User.find_by(email: params[:email])
    if @user.nil?
      render json: { error: 'enter valid email' }
    elsif @user.password_digest == params[:password_digest]
      token = jwt_encode(user_id: @user.id)
      render json: UserSerializer.new(@user).serializable_hash.merge(token:), status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
