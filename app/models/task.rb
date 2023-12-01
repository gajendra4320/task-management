class Task < ApplicationRecord
  belongs_to :user
  has_many :comments
  enum status: { open: 'open', progress: 'progress', closed: 'closed' }
  enum priorities: {high: 'high', medium: 'medium', low: 'low'}
  # validates :status, inclusion: { :in => %w(open medium closed)}
end
