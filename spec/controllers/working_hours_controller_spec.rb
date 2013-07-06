# coding: utf-8
require 'spec_helper'

describe WorkingHoursController do
  let(:organization) {FactoryGirl.create(:organization_with_services)}

  before(:each) do
    @request.host = "#{organization.domain}.com"
  end

  describe "GET self_by_month" do
    before(:each) do
      sign_in user if defined?(user)
      3.times do |t|
        options = {:status => (t.zero? ? 'offer' : 'complete'),
                   :organization_id => organization.id,
                   :start => Time.now + rand(42).hour,
                   :showing_time => '1'}
        options[:user_id] = user.id if defined?(user)
        FactoryGirl.create( :valid_appointment, options )
      end
      get :self_by_month, :format => 'json', :start => Time.now.at_beginning_of_month.to_i, :end => Time.now.at_end_of_month.to_i
    end

    context "not signed in" do
      it { response.should redirect_to(root_path) }
    end

    context "when signed in like user" do
      let(:user){ FactoryGirl.create(:user) }
      it { JSON.parse(response.body).size.should eq(1) }
    end

    context "when signed in like owner" do
      let(:user){ organization.owner }
      it 'should send array' do
        array = JSON.parse(response.body)
        array.find_all{|x| x['data-id']}.size.should eq(3)
        array.find{|x| x['allDay'] = true}.size.should > 0
      end
    end

  end

  describe "GET by_week" do
    it "should return only working hours by week" do
      working_hours_count = 5
      FactoryGirl.create_list(:working_hour, working_hours_count, :organization_id => organization.id)
      get :by_week, :format => 'json', :start => Time.now.at_beginning_of_week.to_i, :end => Time.now.at_end_of_week.to_i
      response.status.should eq(200)
      JSON.parse(response.body).size.should >= working_hours_count
    end
  end

end 
