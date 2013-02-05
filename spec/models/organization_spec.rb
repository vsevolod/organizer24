require "spec_helper"

describe Organization do
  organization = FactoryGirl.create( :organization_with_services )

  context 'services' do
    it 'should show services' do
      organization.get_services(Faker::PhoneNumber.phone_number).size.should equal(3)
    end
  end

  context 'options' do
    it 'should registration before' do
      organization.should be_registration_before
    end
  end

end
