FactoryGirl.define do
  factory :worker do
    organization
    user

    phone { (Random.new.rand * 100_000_000).ceil.to_s }
    name { Faker::Name.first_name }
    is_enabled true

    trait :with_services do
      after(:build) do |worker, _evaluator|
        worker.services = appointment.organization.services.where(is_collection: false)
      end
    end

    trait :working_now do
      after(:build) do |worker, _evaluator|
        worker.working_hours << build(:working_hour, :now, worker: worker)
      end
    end
  end
end
