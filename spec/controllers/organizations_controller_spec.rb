# coding: utf-8
require 'spec_helper'

describe OrganizationsController do

  let(:organization) { FactoryGirl.create(:organization)}
  let(:user) {FactoryGirl.create(:user)}

  before(:each) do
    @request.host = "#{organization.domain}.com"
  end

  describe "GET show" do

    context 'not signed in' do
      it 'should see entry page' do
        get :show
        response.status.should eq(200)
      end
    end

  end

  describe "GET calendar" do

    context 'not signed in' do
      it 'for not signed organization' do
        organization.registration_before = 0
        organization.save!
        get :calendar
        response.status.should eq(200)
      end
      it 'for signed organization' do
        organization.registration_before = 1
        organization.save!
        get :calendar
        response.should redirect_to(root_path(:host => @request.host))
      end
    end

    context 'signed in' do
      it 'like guest' do
        sign_in user
        get :calendar
        response.status.should eq(200)
      end

      it 'like owner' do
        sign_in organization.owner
        get :calendar
        response.status.should eq(200)
      end
    end

    #TODO signed in like worker.

  end

end
