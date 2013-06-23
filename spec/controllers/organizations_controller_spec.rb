# coding: utf-8
require 'spec_helper'

describe OrganizationsController do

  let(:organization) { FactoryGirl.create(:organization)}

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

end
