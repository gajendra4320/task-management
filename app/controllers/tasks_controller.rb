class TasksController < ApiController
  load_and_authorize_resource

  def index
    tasks = Task.all
    render json: tasks, status: :ok
  end

  def create
    @task = @current_user.tasks.create(task_params)
    if @task.present?
      render json: { user: @task }, status: :created
    else
      render json: { message: 'task not created' }, status: :unprocessable_entity
    end
  end

  def update
    if params[:id].present?
      @task = Task.find_by_id(params[:id])
      if @task.nil?
        render json: { message: 'Task not exits for params id' }
      elsif @current_user.user_type == 'Manager'
        @task.update(update_params)
        @user = User.find_by(id: @task.user_id)
        MyMailer.with(task: @task, user: @user).task_updated.deliver_now
        render json: @task, status: :ok
      elsif @current_user.user_type == 'Admin'
        @task.update(task_params)
        @user = User.find_by(id: @task.user_id)
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
    @task = Task.find_by(id: params[:id])
    render json: { task: @task, message: 'Task deleted' }, status: :ok if @task.delete
  end

  def assign_task
    @task = Task.find_by_id(params[:task_id])
    @user = User.find_by_id(params[:user_id])
    @user_task = @user.tasks << @task
    MyMailer.with(task: @task, user: @user).welcome_email.deliver_now
    render json: { user_task: @user_task, message: 'Task assigned to user successfuly' }, status: :ok
  end

  private

  def update_params
    params.permit(:title, :description, :due_date, :priorities, :image)
  end

  def task_params
    params.permit(:title, :description, :due_date, :priorities, :status, :image)
  end
end
