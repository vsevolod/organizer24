# coding: utf-8
require 'spec_helper'

describe WorkersController do
  let(:organization) {FactoryGirl.create(:organization_with_services)}
  let(:worker) {FactoryGirl.create(:worker_with_services, :organization_id => organization.id)}

  before(:each) do
    @request.host = "#{organization.domain}.com"
    @photo = fixture_file_upload('/files/photo.jpg', 'image/jpg')
    sign_in user if defined?(user)
  end

  describe "GET index" do
    before(:each) do
      get :index
    end

    context "when not signed in" do
      it { response.should redirect_to(root_path) }
    end

    context "when signed in like user" do
      let(:user){ FactoryGirl.create(:user) }
      it { response.should redirect_to(root_path) }
    end

    context "when signed in like owner" do
      let(:user){ organization.owner }
      it { response.status.should eq(200) }
    end
  end

  describe "POST create" do
    context 'with valid parameters' do
      let(:worker_user){ FactoryGirl.create(:user) }
      let(:user){ organization.owner }
      subject {
        post :create, :worker => {
          :organization_id => organization.id,
          :name => Faker::Name.first_name,
          :is_enabled => true,
          :phone => (Random.new.rand*100000000).ceil.to_s,
          :photo => @photo
        }
        it {expect { subject }.to change(Worker, :count).by(1)}
      }
    end
  end

  describe "PUT update" do
    context 'with valid parameters' do
      let(:worker_user){ FactoryGirl.create(:user) }
      let(:user){ organization.owner }
      let(:worker){ organization.workers.first }
      
      it 'should change name of worker' do
        new_name = Faker::Name.first_name
        expect {
          put :update, :id => worker.id, :worker => {
            :name => new_name,
            :phone => (Random.new.rand*100000000).ceil.to_s,
            :photo => @photo
          }
        }.to change{worker.reload.name}.to(new_name)
        response.should redirect_to(workers_path)
      end
    end
  end

end
