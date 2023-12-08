# frozen_string_literal: true

# task model
class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image
  enum status: { open: 'open', progress: 'progress', closed: 'closed' }
  enum priorities: { high: 'high', medium: 'medium', low: 'low' }
  validates :title, :description, presence: true
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description due_date id priorities status title updated_at user_id]
  end
end
