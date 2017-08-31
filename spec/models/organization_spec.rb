# == Schema Information
#
# Table name: organizations
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  activity_id :integer
#  domain      :string(255)
#  owner_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  settings    :text
#

require 'spec_helper'

describe Organization do
  let(:organization) { FactoryGirl.create(:organization_with_services) }

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
