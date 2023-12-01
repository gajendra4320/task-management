class TasksController < ApiController
  skip_before_action :authenticate_request, only: %i[create index]
  before_action :authenticate_request
  before_action :check_user, only: [:update]

  def index
    tasks = Task.all
    render json: tasks, status: :ok
  end

  def create
    # @task = Task.new(task_params)
    if @current_user.user_type == 'Admin'
      @task = @current_user.tasks.create(task_params)
      if @task.save
        render json: { user: @task }, status: :created
      else
        render json: { error: @task.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Only Admin Can create Task' }
    end
  end

  def update
    if params[:id].present?
      # @task= @current_user.tasks.find_by_id(params[:id])
      @task = Task.find_by_id(params[:id])
      if @task.nil?
        render json: { message: 'Task not exits for params id' }
      elsif @task.update(task_params)
        render json: @task, status: :ok
      else
        render json: { message: 'task not updated' }
      end
    else
      render json: { message: 'id not present in params' }, status: :ok
    end
  end

  def show
    @task = Task.find_by(id: params[:id])
    render json: @task, status: :ok if @task.present?
  end

  def destroy
    @task = Task.find_by_id(params[:id])
    if @task.present?
      @task.delete
      render json: { task: @task, message: 'Task deleted' }, status: :ok
    else
      render json: { message: 'Please enter valid task id' }, status: :ok
    end
  end

  private

  def check_user
    return if @current_user.user_type == 'Admin' || @current_user.user_type == 'Manger'

    render json: { error: 'Not Allowed' }
  end

  def task_params
    params.permit(:title, :description, :due_date, :priorities, :status)
  end
end
