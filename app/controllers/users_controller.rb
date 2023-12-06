class UsersController < ApiController
  skip_before_action :authenticate_request, only: %i[create index google_oauth2_callback]
  def index
    @users = User.all
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(5)
    render json: @users, meta: { current_page: @users.current_page, total_page: @users.total_pages },
           each_serializer: UserSerializer
    # render json: { users: @users, meta: { current_page: @users.current_page, total_page: @users.total_pages } }
  end

  def create
    @user = User.new(user_params)
    if @user.save
      token = UsersController.new.jwt_encode(user_id: @user.id)
      render json: { user: @user, token: }, status: :created
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def google_oauth2_callback
    # user_info = request.env['omniauth.auth']
    # @user_info = User.from_omniauth(request.env["omniauth.auth"])
    user = User.find_by(email: user_info['info']['email'])
    if user
      token = UsersController.new.jwt_encode(user_id: user.id)
      render json: { user:, token: }, status: :ok
    else
      new_user = User.create(
        name: user_info['info']['name'],
        email: user_info['info']['email']
      )
      if new_user.save
        token = UsersController.new.jwt_encode(user_id: new_user.id)
        render json: { user: new_user, token: }, status: :created
      else
        render json: { error: new_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # def self.from_omniauth(auth)
  # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #   user.provider = auth.provider
  #   user.uid = auth.uid
  #   user.email = auth.info.email
  #   # user.password = Devise.friendly_token[0,20]
  # end

  def update
    if @current_user.update(user_params)
      render json: @current_user, status: :ok
    else
      render json: { error: 'user not exits' }, status: :unprocessable_entity
    end
  end

  def show
    render json: @current_user, status: :ok if @current_user.present?
  end

  def destroy
    if @current_user.present?
      @current_user.delete
      render json: { user: @current_user, message: 'current_user deleted' }, status: :ok
    else
      render json: { message: 'User not present' }, status: :ok
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password_digest, :user_type)
  end
end
