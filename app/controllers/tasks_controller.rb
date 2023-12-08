# frozen_string_literal: true

# task controller
class TasksController < ApiController
  load_and_authorize_resource

  def index
    @tasks = Task.all
    @tasks = Kaminari.paginate_array(@tasks).page(params[:page]).per(5)
    render json: @tasks, meta: { current_page: @tasks.current_page, total_page: @tasks.total_pages },
           each_serializer: TaskSerializer
  end

  def create
    task = @current_user.tasks.create!(task_params)
    render json: TaskSerializer.new(task).serializable_hash, status: :created if task.present?
  end

  def update
    find_task(params[:id])
    if @current_user.user_type == 'Manager'
      @task.update(update_params)
      find_user_tasks(@task)
    elsif @current_user.user_type == 'Admin'
      @task.update(task_params)
      find_user_tasks(@task)
    end
  end

  def show
    find_task(params[:id])
    render json: TaskSerializer.new(@task).serializable_hash, status: :ok if @task.present?
  end

  def destroy
    find_task(params[:id])
    render json: TaskSerializer.new(@task).serializable_hash.merge(message: 'Task deleted'), status: :ok if @task.delete
  end

  def assign_task
    find_task(params[:task_id])
    @user = User.find_by_id(params[:user_id])
    @user_task = @user.tasks << @task
    MyMailer.with(task: @task, user: @user).welcome_email.deliver_now
    render json: TaskSerializer.new(@task).serializable_hash.merge(message: 'Task assigned to user successfuly'),
           status: :ok
  end

  private

  def update_params
    params.permit(:title, :description, :due_date, :priorities, :image)
  end

  def task_params
    params.permit(:title, :description, :due_date, :priorities, :status, :image)
  end

  def find_user_tasks(_task)
    @user = User.find_by(id: @task.user_id)
    MyMailer.with(task: @task, user: @user).task_updated.deliver_now
    render json: @task, status: :ok
  end

  def find_task(id)
    @task = Task.find_by(id:)
  end
end
