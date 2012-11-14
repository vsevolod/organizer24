FactoryGirl.define do

  factory :appointment do
    start Time.now
    showing_time 60
    status 'free'
    cost 100

    user
    after(:build) do |appointment|
      appointment.organization = FactoryGirl.create( :organization_with_services )
    end

    factory :valid_appointment do
      sequence :phone do |n|
        Faker::PhoneNumber.phone_number
      end
      sequence :firstname do |n|
        Faker::Name.first_name
      end
      after(:build) do |appointment, evaluator|
        appointment.services = appointment.organization.services
      end
    end
  end

  factory :page do
    name Faker::Lorem.words(2)
    permalink Faker::Lorem.words(1)
    content Faker::Lorem.paragraphs
  end

  factory :dictionary, :aliases => [:activity] do
    name Faker::Lorem.words(2)
  end

  factory :user, :aliases => [:owner] do
    sequence :email do |n|
      Faker::Internet.email
    end
    phone "+79#{Random.new.rand(10)}#{Random.new.rand(10)}#{Random.new.rand(10)}999999"
    password '1111111'
    password_confirmation '1111111'
    role 'client'
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
  end

  factory :organization do
    sequence :name do
      Faker::Company.name
    end
    sequence :subdomain do
      Faker::Lorem.words(1)
    end
    # settings
    registration_before 1
    theme 'beauty'
    slot_minutes 30
    last_day 0
    # references
    owner
    activity

    factory :organization_with_services do
      ignore do
        services_count 3
      end
      after(:create) do |organization, evaluator|
        FactoryGirl.create_list( :service, evaluator.services_count, :organization => organization )
      end
    end
  end

  factory :service do
    sequence :name do |n|
      Faker::Company.name
    end
    sequence :showing_time do |n|
      Random.new.rand(1..5) * 30
    end
    sequence :cost do |n| 
      Random.new.rand(100..1000)
    end
    is_collection false # test only not collections. fix it
  end

  factory :working_hour do
    week_day     Random.new.rand(1..6)
    begin_time   360 * Random.new.rand(8..12)
    end_time     360 * Random.new.rand(20..255)
  end

end
