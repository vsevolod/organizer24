# coding: utf-8
require 'spec_helper'

describe UsersController do

  let(:appointment) {FactoryGirl.create(:valid_appointment)}
  let(:organization){appointment.organization}
  let(:owner){organization.owner}
  let(:show_user){appointment.user}

  before(:each) do
    @request.host = "#{organization.domain}.com"
    sign_in user if defined?(user)
  end

  describe "GET show for exist user" do
    before(:each) do
      get :show, :id => show_user.phone
    end

    context 'when not logged in' do
      it {response.should redirect_to(new_user_session_path)}
    end

    context 'when logged in like user' do
      let(:user){appointment.user}
      it {response.should redirect_to(dashboard_path)}
    end

    context 'whe logged in like owner' do
      let(:user){organization.owner}
      it { response.status.should eq(200) }
    end
  end

  describe "GET dashboard" do
    before(:each) do
      get :dashboard
    end

    context 'when logged in like user' do
      let(:user){appointment.user}
      it {response.status.should eq(200)}
    end
  end

end
