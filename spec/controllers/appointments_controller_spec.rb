# coding: utf-8
require 'spec_helper'

describe AppointmentsController do
  let(:appointment) {FactoryGirl.create(:valid_appointment, :status => 'offer')}

  before(:each) do
    @request.host = "#{appointment.organization.domain}.com"
  end

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
      let(:user){ appointment.organization.owner }
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
      let(:user){ appointment.organization.owner }
      it { response.body.should =~ /html/ }
    end

    context 'logged in as appointment user' do
      let(:user){ appointment.user }
      it { response.body.should =~ /html/ }
    end
  end

end
