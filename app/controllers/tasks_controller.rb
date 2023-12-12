# frozen_string_literal: true

# task controller
class TasksController < ApiController
  load_and_authorize_resource
  before_action :find_user, except: [:index]
  before_action :find_and_authorize_task, only: %i[update show destroy]
  def index
    @tasks = Task.all
    @tasks = Kaminari.paginate_array(@tasks).page(params[:page]).per(5)
    render json: @tasks, meta: { current_page: @tasks.current_page, total_page: @tasks.total_pages },
           each_serializer: TaskSerializer
  end

  def create
    task = @user.tasks.create!(task_params)
    render json: TaskSerializer.new(task).serializable_hash, status: :created
  end

  def update
    update_task_params = @user.user_type == 'Manager' ? update_params : task_params
    if @task.update(update_task_params)
      find_user_tasks(@task)
    else
      render json: { error: 'Task not updated' }, status: :unprocessable_entity
    end
  end

  def show
    render json: { message: 'You are task is not present' } unless @task.present?
    render json: TaskSerializer.new(@task).serializable_hash, status: :ok
  end

  def destroy
    if @task.destroy
      render json: { message: 'Task deleted successfully' }, status: :ok
    else
      render json: { error: 'Task not deleted' }, status: :unprocessable_entity
    end
  end

  def assign_task
    @task = Task.find_by(params[:task_id])
    @user = User.find_by_id(params[:user_id])
    @user_task = @user.tasks << @task
    find_user_tasks(@user_task)
  end

  private

  def find_user
    @user = User.find_by(id: params[:user_id])
    render json: { error: 'User not found for this id' }, status: :not_found unless @user
  end

  def find_and_authorize_task
    if @user.user_type == 'Admin' && @user.user_type == 'User'
      @task = @user.tasks.find_by(id: params[:id])
      render json: { error: 'Task not exits for this user id ' }, status: :not_found unless @task
      authorize_user
    else
      @task = Task.find_by(id: params[:id])
      render json: { error: 'Task not exits for this user id ' }, status: :not_found unless @task
      authorize_user
    end
  end

  def authorize_user
    return if @current_user.present? && @user == @current_user

    render json: { error: 'please enter login user id' }, status: :unauthorized
  end

  def update_params
    params.permit(:title, :description, :due_date, :priorities, :image)
  end

  def task_params
    params.permit(:title, :description, :due_date, :priorities, :status, :image)
  end

  def find_user_tasks(_task)
    @user = User.find_by(id: @task.user_id)
    MyMailer.with(task: @task, user: @user).task_updated.deliver_now
    render json: TaskSerializer.new(@task).serializable_hash.merge(message: 'Task assigned to user successfuly'),
           status: :ok
  end
end
