# coding: utf-8
require 'spec_helper'

describe PhotosController do

  let(:photo) {FactoryGirl.create(:photo)}
  let(:category_photo) {photo.category_photo}
  let(:organization) {category_photo.organization}

  before(:each) do
    @request.host = "#{organization.domain}.com"
    sign_in organization.owner 
    @photo_file = fixture_file_upload('/files/photo.jpg', 'image/jpg')
  end

  describe "POST create" do
    let(:valid_attributes){ {photo: [@photo_file]} }

    it 'should create photo' do
      expect {
        post :create, photo: valid_attributes, category_photo_id: category_photo.id, :format => 'js'
      }.to change(Photo, :count).by(1)
    end
  end

  describe "DELETE destroy" do
    it 'should destroy category_photo' do
      expect {
        delete :destroy, id: photo.id, category_photo_id: category_photo.id, :format => 'js'
      }.to change(Photo, :count).by(-1)
    end
  end

end
