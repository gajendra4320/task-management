# frozen_string_literal: true

# comments controller
class CommentsController < ApiController
  load_and_authorize_resource
  before_action :find_user_task
  before_action :find_comment, only: %i[update show destroy]

  def create
    authorize_user
    @comment = Comment.create(comment_params)
    send_email_to_user(@task, @user, @comment)
  end

  def update
    authorize_user_comment
    return unless @comment.update(comment_params)

    render json: CommentSerializer.new(@comment).serializable_hash.merge(message: 'Comment updated successfully'),
           status: :ok
  end

  def show
    render json: CommentSerializer.new(@comment).serializable_hash, status: :ok
  end

  def index
    comments = @task.comments.page(params[:page]).per(5)
    render json: comments, meta: { current_page: comments.current_page, total_page: comments.total_pages },
           each_serializer: CommentSerializer
  end

  def destroy
    authorize_user_comment
    return unless @comment.destroy

    render json: CommentSerializer.new(@comment).serializable_hash.merge(message: 'Comment deleted successfully'),
           status: :ok
  end

  private

  def find_user_task
    @user = User.find_by(id: params[:user_id])
    @task = Task.find_by(id: params[:task_id])

    render json: { error: 'User or Task not found for this id' }, status: :not_found unless @user && @task
  end

  def find_comment
    @comment = @task.comments.find_by(id: params[:id])
    render json: { error: 'Comment not found for this task id' }, status: :not_found unless @comment
  end

  def authorize_user
    return if @current_user.present? && @user == @current_user

    render json: { error: 'Unauthorized action' }, status: :unauthorized
  end

  def authorize_user_comment
    authorize_user
    return if @comment.user == @current_user

    render json: { error: 'Unauthorized action on this comment' }, status: :unauthorized
  end

  def send_email_to_user(task, user, comment)
    MyMailer.with(task:, user:, comment:).comments_on_task.deliver_now
    render json: CommentSerializer.new(@comment).serializable_hash, status: :created
  end

  def comment_params
    params.permit(:title, :task_id, :user_id)
  end
end
