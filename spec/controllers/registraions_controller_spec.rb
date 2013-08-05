# coding: utf-8
require 'spec_helper'

describe RegistrationsController do
  render_views


  describe 'GET new first step' do

    it 'be success' do
      get :new
      response.status.should eq(200)
    end

  end

end
