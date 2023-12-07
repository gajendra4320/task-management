FactoryBot.define do
  factory :user, class: 'User' do
    name { Faker::Name.name }
    email  { Faker::Name.name }
    password_digest {Faker::Internet.password}
    user_type { "Admin" }
    # location  { "indore" }
    # association :task
    # association :comment
  end
end

