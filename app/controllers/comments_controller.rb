class CommentsController < ApiController
  skip_before_action :authenticate_request, only: %i[create index]
  before_action :authenticate_request
  def create
    if @comment = @current_user.comments.create(comment_params)
      render json: { user: @comment }, status: :created
    else
      render json: { error: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if params[:id].present?
      # @task= @current_user.tasks.find_by_id(params[:id])
      @comment = Comment.find_by_id(params[:id])
      if @comment.nil?
        render json: { message: 'Comment not exits for params id' }
      elsif @comment.update(comment_params)
        render json: @comment, status: :ok
      else
        render json: { message: 'comment not updated' }
      end
    else
      render json: { message: 'id not present in params' }, status: :ok
    end
  end

  def show
    @comment = Comment.find_by(id: params[:id])
    render json: @comment, status: :ok if @comment.present?
  end

  def index
    @comments = Comment.all
    render json: @comments, status: :ok
  end

  def destroy
    @comment = Comment.find_by_id(params[:id])
    if @comment.delete
      render json: { comment: @comment, message: 'comment deleted' }, status: :ok
    else
      render json: { message: 'Please enter valid task id' }, status: :ok
    end
  end

  private

  def comment_params
    params.permit(:title, :task_id)
  end
end
