# require 'spec_helper'
#
# describe SmsJob do
#
#  let(:organization){ FactoryGirl.create(:organization) }
#  let(:appointments){ FactoryGirl.create_list(:appointment, 50, organization: organization)}
#
#  before(:each) do
#    @options = {organization_id: organization.id}
#    Smsru.stub(:send)
#  end
#
#  describe 'test perform method' do
#
#    context 'when sms_type is day_report' do
#
#    end
#
#  end
#
# end
