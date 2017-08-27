require 'rails_helper'

RSpec.describe AppointmentsController do
  render_views

  # let(:appointment)  { create(:appointment, :valid, :with_organization, status: 'offer') }
  # let(:organization) { appointment.organization }

  # before(:each) do
  #   @request.host = "#{organization.domain}.com"
  #   sign_in user if defined?(user)
  # end

  # describe 'GET #show' do
  #   before(:each) do
  #     get :show, params: { id: appointment.id }
  #   end

  #   context 'when not logged in' do
  #     it { response.should redirect_to(root_path) }
  #   end

  #   context 'when logged in as other user' do
  #     let(:user) { create(:user) }
  #     it { response.should redirect_to(root_path) }

  #     context 'and user phone equal appointment phone' do
  #       let(:appointment) { create(:appointment, :valid, :with_organization, user_id: nil, phone: user.phone, status: 'free') }
  #       it { response.status.should eq(200) }
  #     end
  #   end

  #   context 'when logged in as organization owner' do
  #     let(:user) { organization.owner }
  #     it { response.status.should eq(200) }
  #   end

  #   context 'logged in as appointment user' do
  #     let(:user) { appointment.user }
  #     it { response.status.should eq(200) }
  #   end
  # end

  # describe 'GET #edit' do
  #   before(:each) do
  #     get :edit, params: { format: 'js', id: appointment.id }
  #   end

  #   context 'when not logged in' do
  #     it { response.body.should =~ /alert/ }
  #   end

  #   context 'when logged in as other user' do
  #     let(:user) { create(:user) }
  #     it { response.body.should =~ /alert/ }
  #   end

  #   context 'when logged in as organization owner' do
  #     let(:user) { organization.owner }
  #     it { response.body.should =~ /html/ }
  #   end

  #   context 'logged in as appointment user' do
  #     let(:user) { appointment.user }
  #     it { response.body.should =~ /html/ }
  #   end
  # end

  # describe 'GET #by_week' do
  #   before(:each) do
  #     # app1 = appointment
  #     app2 = create(:appointment, :valid, organization: organization, start: Time.now - 24.hours)
  #     app3 = create(:appointment, :valid, organization: organization, start: Time.now + 24.hours)
  #     app4 = create(:appointment, :valid, organization: organization, start: app3._end)
  #     app5 = create(:appointment, :valid, organization: organization, start: app4._end)

  #     ########################################################
  #     #      | statuses | not signed in | app5 user | owner |#
  #     # app1 | offer    |       +       |     +     |   +   |#
  #     # app2 | complete |               |           |   +   |#
  #     # app3 | cancel   |               |           |   +   |#
  #     # app4 | offer    |       +       |     +     |   +   |#
  #     # app5 | offer    |               |     +     |   +   |#
  #     ########################################################

  #     # organization have 5 appointments
  #     app2.complete_appointment!
  #     app3.cancel_appointment_by_client!
  #     app4.first_owner_view!
  #     app5.first_owner_view
  #     app5.user = user if defined?(user)
  #     app5.save
  #     _start = organization.appointments.order(:start).first.start - 1.day
  #     _end   = organization.appointments.order(:start).last.start + 1.day
  #     get :by_week, params: { format: 'json', id: appointment.id, worker_id: organization.workers.first.id, start: _start, end: _end, statuses: Appointment.aasm.states.map(&:to_s) }
  #     @parsed_body = JSON.parse(response.body)
  #   end

  #   context 'when not logged in' do
  #     it { @parsed_body.should have(2).items }
  #   end

  #   context 'when logged in as app4 user' do
  #     let(:user) { create(:user) }
  #     it { @parsed_body.should have(2).items }
  #   end

  #   context 'when logged in as organization owner' do
  #     let(:user) { organization.owner }
  #     it { @parsed_body.should have(5).items }
  #   end
  # end

  # describe 'GET #phonebook' do
  #   before(:each) do
  #     get :phonebook
  #   end

  #   context 'when logged in as user' do
  #     let(:user) { create(:user) }
  #     it { response.should redirect_to(root_path) }
  #   end

  #   context 'when logged in as organization owner' do
  #     let(:user) { organization.owner }
  #     it 'should see users phones' do
  #       response.body.should have_selector('table.table', text: appointment.phone)
  #     end
  #   end
  # end

  describe 'POST #create' do
    include_context :logged_in

    let!(:attributes) do
      {
        start: Time.now,
        appointment: attributes_for(:appointment),
        user: {
          phone: user.phone,
          firstname: user.firstname,
          lastname: user.lastname,
          showing_time: 30,
          comment: ''
        }
      }
    end
    let(:request) { -> { post :create, params: attributes } }

    it 'adds new appointment' do
      travel_to 1.day.ago do
        expect { request.call }
          .to change(Appointment, :count).by(1)
      end
    end

    context 'multiple queries' do
      let(:threads_count) { 2 }

      it 'creates only one appointment', clean_up: :truncate do
        travel_to 1.day.ago do
          threads = Array.new(threads_count).map do
            Thread.new do
              begin
                request.call
              rescue
                nil
              end
            end
          end

          expect { threads.each(&:join) }.to change(Appointment, :count).by(1)
        end
      end
    end
  end
end
