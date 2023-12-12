# frozen_string_literal: true

# users controller
class UsersController < ApiController
  skip_before_action :authenticate_request, only: %i[create google_oauth2_callback]
  before_action :find_and_authorize_user, only: %i[destroy show update]
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

  def google_oauth2_callback
    @user_info = request.env['omniauth.auth']
    @user = User.find_by(email: @user_info['info']['email'])
    if @user.present?
      token = UsersController.new.jwt_encode(user_id: @user.id)
      render json: UserSerializer.new(@user).serializable_hash.merge(token:), status: :created
    else
      @new_user = User.new(
        name: @user_info['info']['name'],
        email: @user_info['info']['email'],
        password_digest: @user_info['info']['email'],
        user_type: 'User'
      )
      if @new_user.save
        token = UsersController.new.jwt_encode(user_id: @new_user.id)
        render json: UserSerializer.new(@new_user).serializable_hash.merge(token:), status: :created
      else
        render json: { error: @new_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @user.destroy!
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: { error: 'User not deleted' }
    end
  end

  def show
    render json: UserSerializer.new(@user).serializable_hash, status: :ok
  end

  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render json: { error: 'User not updated' }
    end
  end

  private

  def find_and_authorize_user
    @user = User.find_by(id: params[:id])

    unless @user
      render json: { error: 'User not found for this id' }, status: :not_found
      return
    end

    return if @current_user.present? && @user == @current_user

    render json: { error: 'please enter your id' }, status: :unauthorized
  end

  def user_params
    params.permit(:name, :email, :password_digest, :user_type)
  end
end
