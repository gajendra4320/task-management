# frozen_string_literal: true

# comments controller
class CommentsController < ApiController
  load_and_authorize_resource
  def create
    @comment = @current_user.comments.create(comment_params)
    @task = Task.find_by_id(params[:task_id])
    @user = User.find_by_id(@task.user_id)
    MyMailer.with(task: @task, user: @user, comment: @comment).comments_on_task.deliver_now
    render json: CommentSerializer.new(@comment).serializable_hash, status: :created
  end

  def update
    comment = @current_user.comments.find_by(id: params[:id])
    return unless comment.update(comment_params)

    render json: CommentSerializer.new(comment).serializable_hash.merge(message: 'comment updated ff'),
           status: :ok
  end

  def show
    @comment = Comment.find_by(id: params[:id])
    render json: CommentSerializer.new(@comment).serializable_hash, status: :ok
  end

  def index
    comments = Comment.all
    comments = Kaminari.paginate_array(comments).page(params[:page]).per(5)
    render json: comments, meta: { current_page: comments.current_page, total_page: comments.total_pages },
           each_serializer: CommentSerializer
  end

  def destroy
    comment = @current_user.comments.find_by(id: params[:id])
    return unless comment.delete

    render json: CommentSerializer.new(comment).serializable_hash.merge(message: 'comment deleted'),
           status: :ok
  end

  private

  def comment_params
    params.permit(:title, :task_id)
  end
end
