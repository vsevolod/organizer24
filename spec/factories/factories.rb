FactoryGirl.define do
  factory :page do
    name Faker::Lorem.words(2)
    permalink Faker::Lorem.words(1).first
    content Faker::Lorem.paragraphs
  end

  factory :dictionary, aliases: [:activity] do
    name Faker::Lorem.words(2)
  end

  # factory :organizations_owner do
  #  association(:user, :factory => :owner)
  #  association(:my_organization, :factory => :organization)
  # end

  factory :category_photo do
    sequence :name do
      Faker::Company.name
    end
    organization
    factory :category_photo_with_photos do
      after(:build) do |category_photo, _evaluator|
        FactoryGirl.create_list(:photo, 3, category_photo: category_photo)
      end
    end
  end

  factory :photo do
    name 'photo'
    # photo { fixture_file_upload('/files/photo.jpg', 'image/jpg') }
    photo_file_name { 'photo.jpg' }
    photo_content_type { 'image/jpg' }
    photo_file_size 1024
    category_photo
  end

  factory :service do
    sequence :name do |_n|
      Faker::Company.name
    end
    sequence :showing_time do |_n|
      Random.new.rand(1..5) * 30
    end
    sequence :cost do |_n|
      Random.new.rand(100..1000)
    end
    is_collection false

    factory :multi_service do
      is_collection true

      transient do
        services_count 3
      end

      after(:build) do |service, evaluator|
        service_ids = Array.new(Random.new.rand(2..evaluator.services_count)) do |_el|
          fg = FactoryGirl.create(:service, organization: evaluator.organization)
          fg.id
        end
        service.service_ids = service_ids
      end
    end
  end
end
