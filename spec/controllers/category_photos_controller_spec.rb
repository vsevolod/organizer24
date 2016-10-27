# coding: utf-8
require 'spec_helper'

describe CategoryPhotosController do
  let(:organization) { FactoryGirl.create(:organization) }
  let(:category_photo) { organization.category_photos.first }

  before(:each) do
    @request.host = "#{organization.domain}.com"
    sign_in user if defined?(user)
  end

  describe 'GET index' do
    before(:each) do
      category_photo2 if defined?(category_photo2)
      get :index
    end

    context 'when not logged in' do
      it 'should redirect to #show if one category' do
        response.should redirect_to(category_photo)
      end

      context 'should be success' do
        let(:category_photo2) { FactoryGirl.create(:category_photo, organization: organization) }
        it { response.status.should eq(200) }
      end
    end

    context 'when logged in like owner' do
      let(:user) { organization.owner }
      it { response.status.should eq(200) }
    end
  end

  describe 'GET new' do
    before(:each) do
      get :new
    end

    context 'when logged in like other user' do
      let(:user) { FactoryGirl.create(:user) }
      it { response.should redirect_to(root_path) }
    end

    context 'when logged in like owner' do
      let(:user) { organization.owner }
      it { response.status.should eq(200) }
    end
  end

  describe 'GET edit' do
    before(:each) do
      get :edit, params: { id: category_photo.id }
    end

    context 'when logged in like other user' do
      let(:user) { FactoryGirl.create(:user) }
      it { response.should redirect_to(root_path) }
    end

    context 'when logged in like owner' do
      let(:user) { organization.owner }
      it { response.status.should eq(200) }
    end
  end

  describe 'GET show' do
    before(:each) do
      get :show, params: { id: category_photo.id }
    end
    it { response.status.should eq(200) }
  end

  describe 'POST create' do
    let(:valid_attributes) { { name: Faker::Lorem.word } }
    let(:invalid_attributes) { {} }
    let(:user) { organization.owner }

    it 'should create category_photo' do
      expect do
        post :create, params: { category_photo: valid_attributes }
      end.to change(CategoryPhoto, :count).by(1)
    end

    it 'should not create category_photo' do
      expect do
        post :create, params: { category_photo: invalid_attributes }
      end.not_to change(CategoryPhoto, :count).by(1)
    end
  end

  describe 'PUT update' do
    let(:user) { organization.owner }
    it 'should change name for categry_photo' do
      new_name = Faker::Lorem.word
      expect do
        put :update, params: { id: category_photo.id, category_photo: { name: new_name } }
      end.to change { category_photo.reload.name }.to(new_name)
    end
  end

  describe 'DELETE destroy' do
    let(:user) { organization.owner }
    it 'should destroy categry_photo' do
      expect do
        delete :destroy, params: { id: category_photo.id }
      end.to change(CategoryPhoto, :count).by(-1)
    end
  end
end
