FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    domain { Faker::Lorem.words(1).first }

    # settings
    registration_before 1
    theme 'beauty'
    slot_minutes 30
    last_day 0
    timezone { ActiveSupport::TimeZone::MAPPING.to_a.sample.first }

    # references
    activity
    owner

    after(:create) do |organization, _evaluator|
      FactoryGirl.create(:category_photo, organization: organization)
    end

    trait :with_worker do
      after(:create) do |organization, _evaluator|
        FactoryGirl.create(:worker, :working_now, organization: organization)
      end
    end

    trait :with_services do
      after(:create) do |organization, _evaluator|
        FactoryGirl.create_list(:service, 3, organization: organization)
      end
    end

    trait :with_multi_services do
      after(:create) do |organization, _evaluator|
        FactoryGirl.create_list(:multi_service, 3, organization: organization)
      end
    end
  end
end
