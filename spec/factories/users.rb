FactoryBot.define do
  factory :user do
    email    { Faker::Internet.email }
    password { Faker::Number.number(10) }
    admin    { true }
  end
end