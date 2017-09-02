FactoryGirl.define do
  factory :appointment do
    start Time.current + Random.new.rand(1..10).hours
    status 'free'
    cost 100
    user

    after(:build) do |appointment|
      appointment.phone = appointment.user.phone if appointment.user
    end

    trait :with_organization do
      organization factory: [:organization, :with_services]

      after(:build) do |appointment|
        appointment.worker = appointment.organization.workers.take
      end
    end

    trait :completed do
      showing_time 30
      status :complete
    end

    trait :valid do
      sequence :phone do |_n|
        (Random.new.rand * 100_000_000).ceil.to_s
      end
      sequence :firstname do |_n|
        Faker::Name.first_name
      end
      after(:build) do |appointment, _evaluator|
        appointment.services = appointment.organization.services
      end
    end

    trait :multi_services do
      sequence :phone do |_n|
        (Random.new.rand * 100_000_000).ceil.to_s
      end
      sequence :firstname do |_n|
        Faker::Name.first_name
      end

      after(:build) do |appointment, _evaluator|
        appointment.organization = FactoryGirl.create(:organization_with_multi_services)
        appointment.services = appointment.organization.services.where(is_collection: false)
      end
    end
  end
end
