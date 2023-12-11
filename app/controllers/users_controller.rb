# frozen_string_literal: true

# users controller
class UsersController < ApiController
  skip_before_action :authenticate_request, only: %i[create google_oauth2_callback]
  before_action :find_and_authorize_user, only: [:destroy, :show]
  def index
    @users = User.all
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(5)
    render json: @users, meta: { current_page: @users.current_page, total_page: @users.total_pages },
           each_serializer: UserSerializer
  end

  def create
    user = User.new(user_params)
    if user.save
      token = UsersController.new.jwt_encode(user_id: user.id)
      render json: UserSerializer.new(user).serializable_hash.merge(token:), status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # def google_oauth2_callback
  # user_info = request.env['omniauth.auth']
  # @user_info = User.from_omniauth(request.env["omniauth.auth"])
  #   user = User.find_by(email: user_info['info']['email'])
  #   if user
  #     token = UsersController.new.jwt_encode(user_id: user.id)
  #     render json: { user:, token: }, status: :ok
  #   else
  #     new_user = User.create(
  #       name: user_info['info']['name'],
  #       email: user_info['info']['email']
  #     )
  #     if new_user.save
  #       token = UsersController.new.jwt_encode(user_id: new_user.id)
  #       render json: { user: new_user, token: }, status: :created
  #     else
  #       render json: { error: new_user.errors.full_messages }, status: :unprocessable_entity
  #     end
  #   end
  # end

  # def self.from_omniauth(auth)
  # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #   user.provider = auth.provider
  #   user.uid = auth.uid
  #   user.email = auth.info.email
  #   # user.password = Devise.friendly_token[0,20]
  # end

  def destroy
    if @user.destroy!
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: { error: 'User not deleted'}
    end
  end

  def show
    render json: UserSerializer.new(@user).serializable_hash, status: :ok
  end

  private

  def find_and_authorize_user
    @user = User.find_by(id: params[:id])

    unless @user
      render json: { error: 'User not found for this id' }, status: :not_found
      return
    end

    unless @current_user.present? && @user == @current_user
      render json: { error: 'please enter your id' }, status: :unauthorized
    end
  end

  def user_params
    params.permit(:name, :email, :password_digest, :user_type)
  end
end
