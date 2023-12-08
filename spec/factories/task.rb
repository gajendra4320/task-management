# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: 'Task' do
    title { Faker::Name.name }
    description { Faker::Name.name }
    due_date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    priorities { 'high' }
    status { 'open' }
    association :user
  end
end
