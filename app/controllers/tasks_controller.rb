class TasksController < ApiController
  # skip_before_action :authenticate_request, only: %i[ index]
  # before_action :authenticate_request
  load_and_authorize_resource
  # before_action :check_user, only: [:update]

  def index
    tasks = Task.all
    render json: tasks, status: :ok
  end

  def create
    @task = Task.new(task_params)
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
        @user = User.find_by_id(@task.user_id)
        MyMailer.with(task: @task, user: @user).task_updated.deliver_now
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


  def assign_task
    @task = Task.find_by_id(params[:task_id])
    @user = User.find_by_id(params[:user_id])
    @user_task = @user.tasks << @task
    MyMailer.with(task: @task, user: @user).welcome_email.deliver_now
    render json: {user_task: @user_task, message: 'Task assigned to user successfuly'}, status: :ok
  end

  private

  def task_params
    params.permit(:title, :description, :due_date, :priorities, :status, :image)
  end
end
