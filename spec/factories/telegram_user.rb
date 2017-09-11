FactoryGirl.define do
  factory :telegram_user do
    telegram_id { SecureRandom.rand(100000) }
    username { Faker::FamilyGuy.character }
  end
end
