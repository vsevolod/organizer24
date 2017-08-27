FactoryGirl.define do
  factory :user, aliases: [:owner] do
    User.skip_callback(:update, :after, :send_confirmation_instructions)

    email { Faker::Internet.email }
    phone { (Random.new.rand * 100_000_000).ceil.to_s }
    password '1111111'
    password_confirmation '1111111'
    role 'client'
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name

    after(:create, &:confirm!)
  end
end
