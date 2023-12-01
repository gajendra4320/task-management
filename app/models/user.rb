class User < ApplicationRecord
  validates :user_type, inclusion: { :in => %w(User Manager Admin)}
  has_many :tasks
  has_many :comments
end
