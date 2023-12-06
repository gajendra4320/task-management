class TaskSerializer < ActiveModel::Serializer
  belongs_to :user
  attributes :id, :title,:description,:due_date, :status, :priorities,:user_id, :image
  def image
    Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attached?
  end
end
