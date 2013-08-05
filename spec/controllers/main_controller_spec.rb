# coding: utf-8
require 'spec_helper'

describe MainController do
  render_views

  describe 'GET index' do
    it 'should be success' do
      get :index
      response.status.should eq(200)
    end
  end

  
end
