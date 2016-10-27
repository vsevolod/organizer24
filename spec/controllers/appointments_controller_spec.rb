# coding: utf-8
require 'spec_helper'

describe AppointmentsController do
  render_views
  let(:appointment)  { FactoryGirl.create(:valid_appointment, status: 'offer') }
  let(:organization) { appointment.organization }

  before(:each) do
    @request.host = "#{organization.domain}.com"
    sign_in user if defined?(user)
  end

  describe 'GET show' do
    before(:each) do
      get :show, params: { id: appointment.id }
    end

    context 'when not logged in' do
      it { response.should redirect_to(root_path) }
    end

    context 'when logged in as other user' do
      let(:user) { FactoryGirl.create(:user) }
      it { response.should redirect_to(root_path) }

      context 'and user phone equal appointment phone' do
        let(:appointment) { FactoryGirl.create(:valid_appointment, user_id: nil, phone: user.phone, status: 'free') }
        it { response.status.should eq(200) }
      end
    end

    context 'when logged in as organization owner' do
      let(:user) { organization.owner }
      it { response.status.should eq(200) }
    end

    context 'logged in as appointment user' do
      let(:user) { appointment.user }
      it { response.status.should eq(200) }
    end
  end

  describe 'GET edit' do
    before(:each) do
      get :edit, params: { format: 'js', id: appointment.id }
    end

    context 'when not logged in' do
      it { response.body.should =~ /alert/ }
    end

    context 'when logged in as other user' do
      let(:user) { FactoryGirl.create(:user) }
      it { response.body.should =~ /alert/ }
    end

    context 'when logged in as organization owner' do
      let(:user) { organization.owner }
      it { response.body.should =~ /html/ }
    end

    context 'logged in as appointment user' do
      let(:user) { appointment.user }
      it { response.body.should =~ /html/ }
    end
  end

  describe 'GET by_week' do
    before(:each) do
      # app1 = appointment
      app2 = FactoryGirl.create(:valid_appointment, organization_id: organization.id, start: Time.now - 24.hours)
      app3 = FactoryGirl.create(:valid_appointment, organization_id: organization.id, start: Time.now + 24.hours)
      app4 = FactoryGirl.create(:valid_appointment, organization_id: organization.id, start: app3._end)
      app5 = FactoryGirl.create(:valid_appointment, organization_id: organization.id, start: app4._end)

      ########################################################
      #      | statuses | not signed in | app5 user | owner |#
      # app1 | offer    |       +       |     +     |   +   |#
      # app2 | complete |               |           |   +   |#
      # app3 | cancel   |               |           |   +   |#
      # app4 | offer    |       +       |     +     |   +   |#
      # app5 | offer    |               |     +     |   +   |#
      ########################################################

      # organization have 5 appointments
      app2.complete_appointment!
      app3.cancel_appointment_by_client!
      app4.first_owner_view!
      app5.first_owner_view
      app5.user = user if defined?(user)
      app5.save
      _start = organization.appointments.order(:start).first.start - 1.day
      _end   = organization.appointments.order(:start).last.start + 1.day
      get :by_week, params: { format: 'json', id: appointment.id, worker_id: organization.workers.first.id, start: _start, end: _end, statuses: Appointment.aasm_states.map(&:to_s) }
      @parsed_body = JSON.parse(response.body)
    end

    context 'when not logged in' do
      it { @parsed_body.should have(2).items }
    end

    context 'when logged in as app4 user' do
      let(:user) { FactoryGirl.create(:user) }
      it { @parsed_body.should have(2).items }
    end

    context 'when logged in as organization owner' do
      let(:user) { organization.owner }
      it { @parsed_body.should have(5).items }
    end
  end

  describe 'GET phonebook' do
    before(:each) do
      get :phonebook
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create(:user) }
      it { response.should redirect_to(root_path) }
    end

    context 'when logged in as organization owner' do
      let(:user) { organization.owner }
      it 'should see users phones' do
        response.body.should have_selector('table.table', text: appointment.phone)
      end
    end
  end
end
