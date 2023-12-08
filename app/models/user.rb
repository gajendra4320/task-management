# frozen_string_literal: true

# user modle
class User < ApplicationRecord
  validates :user_type, inclusion: { in: %w[User Manager Admin] }
  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  def self.ransackable_attributes(_auth_object = nil)
    %w[email id name user_type]
  end
end
