FactoryGirl.define do

  factory :appointment do
    start Time.zone.now + Random.new.rand(1..10).hours
    status 'free'
    cost 100
    user

    after(:build) do |appointment|
      if appointment.user
        appointment.phone = appointment.user.phone
      end
    end

    factory :with_organization do
      after(:build) do |appointment|
        unless appointment.organization
          appointment.organization = FactoryGirl.create( :organization_with_services )
        end
        appointment.worker = appointment.organization.workers.first
      end

      factory :valid_appointment do
        sequence :phone do |n|
          (Random.new.rand*100000000).ceil.to_s
        end
        sequence :firstname do |n|
          Faker::Name.first_name
        end
        after(:build) do |appointment, evaluator|
          appointment.services = appointment.organization.services
        end
      end

    end

    factory :multi_services_appointment do
      sequence :phone do |n|
        (Random.new.rand*100000000).ceil.to_s
      end
      sequence :firstname do |n|
        Faker::Name.first_name
      end

      after(:build) do |appointment, evaluator|
        appointment.organization = FactoryGirl.create( :organization_with_multi_services )
        appointment.services = appointment.organization.services.where( :is_collection => false )
      end
    end

  end

  factory :page do
    name Faker::Lorem.words(2)
    permalink Faker::Lorem.words(1).first
    content Faker::Lorem.paragraphs
  end

  factory :dictionary, :aliases => [:activity] do
    name Faker::Lorem.words(2)
  end

  factory :user, :aliases => [:owner] do
    sequence :email do |n|
      Faker::Internet.email
    end
    sequence :phone do |n|
      (Random.new.rand*100000000).ceil.to_s
    end
    password '1111111'
    password_confirmation '1111111'
    role 'client'
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
  end

  #factory :organizations_owner do
  #  association(:user, :factory => :owner)
  #  association(:my_organization, :factory => :organization)
  #end

  factory :worker do
    organization
    sequence :phone do |n|
      (Random.new.rand*100000000).ceil.to_s
    end
    sequence :name do
      Faker::Name.first_name
    end
    factory :enabled_worker do
      is_enabled true
    end
  end

  factory :category_photo do
    sequence :name do
      Faker::Company.name
    end
    organization
  end

  factory :organization do
    sequence :name do
      Faker::Company.name
    end
    sequence :domain do
      Faker::Lorem.words(1).first
    end

    # settings
    registration_before 1
    theme 'beauty'
    slot_minutes 30
    last_day 0

    # references
    activity
    owner
    after(:create) do |organization|
      #FactoryGirl.create(:organizations_owner, my_organization: organization)
      FactoryGirl.create(:worker, organization: organization)
      FactoryGirl.create(:category_photo, organization: organization)
    end

    factory :organization_with_services do
      ignore do
        services_count 3
      end
      after(:create) do |organization, evaluator|
        FactoryGirl.create_list( :service, evaluator.services_count, :organization => organization )
      end
    end

    factory :organization_with_multi_services do
      ignore do
        services_count 3
      end
      after(:create) do |organization, evaluator|
        FactoryGirl.create_list( :multi_service, evaluator.services_count, :organization => organization )
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
    is_collection false

    factory :multi_service do
      is_collection true

      ignore do
        services_count 3
      end

      after(:build) do |service, evaluator|
        service_ids = Array.new(Random.new.rand(2..evaluator.services_count)) do |el|
          fg = FactoryGirl.create( :service, :organization => evaluator.organization )
          fg.id
        end
        service.service_ids = service_ids
      end

    end
  end

  factory :working_hour do
    week_day     Random.new.rand(1..6)
    begin_time   360 * Random.new.rand(8..12)
    end_time     360 * Random.new.rand(20..255)
  end

end
