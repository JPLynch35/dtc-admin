FactoryBot.define do
  factory :donation do
    stripe_id     { Faker::Number.number(10) }
    name          { Faker::StarWars.character }
    email         { Faker::Internet.email }
    city          { Faker::Address.city }
    state         { Faker::Address.state }
    amount        { 25 }
    date          { Faker::Time.between(2.days.ago, Time.now, :all) }
    donation_type { "Credit" }
  end

  factory :check_donation, parent: :donation do
    stripe_id     { "" }
    donation_type { "Check" }
  end
end