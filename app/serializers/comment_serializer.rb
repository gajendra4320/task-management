class CommentSerializer < ActiveModel::Serializer
  attributes :id, :title, :user_id, :task_id
end
