# frozen_string_literal: true

FactoryBot.define do
  factory :comment, class: 'Comment' do
    title { Faker::Name.name }
    association :user
    association :task
  end
end
