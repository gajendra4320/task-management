class User < ApplicationRecord
  validates :user_type, inclusion: { :in => %w(User Manager Admin)}
  has_many :tasks,  dependent: :destroy
  has_many :comments,  dependent: :destroy
  validates :email, :presence => true, :uniqueness => true
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "name", "password_digest", "updated_at", "user_type"]
  end
end
