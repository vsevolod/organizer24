# coding: utf-8
require 'spec_helper'

describe AppointmentsController do
  let(:appointment)  {FactoryGirl.create(:valid_appointment, :status => 'offer')}
  let(:organization) {appointment.organization}

  before(:each) do
    @request.host = "#{organization.domain}.com"
  end
  pending "Pending while writing other specs" do

  describe "GET show" do
    before(:each) do
      sign_in user if defined?(user)
      get :show, :id => appointment.id
    end

    context 'when not logged in' do
      it { response.should redirect_to(root_path) }
    end

    context 'when logged in as other user' do
      let(:user){ FactoryGirl.create(:user) }
      it { response.should redirect_to(root_path) }

      context 'and user phone equal appointment phone' do
        let(:appointment) {FactoryGirl.create(:valid_appointment, :user_id => nil, :phone => user.phone, :status => 'free')}
        it { response.status.should eq(200) }
      end
    end

    context 'when logged in as organization owner' do
      let(:user){ organization.owner }
      it { response.status.should eq(200) }
    end

    context 'logged in as appointment user' do
      let(:user){ appointment.user }
      it { response.status.should eq(200) }
    end
  end

  describe "GET edit" do
    before(:each) do
      sign_in user if defined?(user)
      get :edit, :format => 'js', :id => appointment.id
    end

    context 'when not logged in' do
      it { response.body.should =~ /alert/}
    end

    context 'when logged in as other user' do
      let(:user){ FactoryGirl.create(:user) }
      it { response.body.should =~ /alert/ }
    end

    context 'when logged in as organization owner' do
      let(:user){ organization.owner }
      it { response.body.should =~ /html/ }
    end

    context 'logged in as appointment user' do
      let(:user){ appointment.user }
      it { response.body.should =~ /html/ }
    end
  end
  end

  describe "GET by_week" do
    before(:each) do
      sign_in user if defined?(user)
      FactoryGirl.create(:valid_appointment, :organization_id => organization.id, :start => Time.now + 24.hour)
      FactoryGirl.create(:valid_appointment, :organization_id => organization.id, :start => Time.now - 24.hour)
      _start = organization.appointments.order(:start).first - 1.minute
      _end   = organization.appointments.order(:start).last  + 1.minute
      get :by_week, :format => 'js', :id => appointment.id, :worker_id => organization.workers.first.id, :start => _start, :end => _end
    end

    context 'when not logged in' do
      it { response.body.should =~ /alert/ }
    end

    context 'when logged in as other user' do
      let(:user){ FactoryGirl.create(:user) }
      it { response.body.should =~ /alert/ }
    end

    context 'when logged in as organization owner' do
      let(:user){ organization.owner }
      it { response.body.should =~ /html/ }
    end
  end

end
