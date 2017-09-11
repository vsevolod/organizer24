require 'rails_helper'

RSpec.describe Operations::Notifications::DayReport do
  subject { described_class.new(options) }
  let(:organization) { create(:organization, :with_services) }
  let!(:worker) { create(:worker, :working_all_week, organization: organization) }
  let(:except_ids) { nil }
  let(:options) { { organization_id: organization.id, except_ids: except_ids } }

  describe '#text' do
    it { expect(subject.text).to be_empty }

    context 'with appointments' do
      let(:appointment_proc) do
        -> {
          create(
            :appointment,
            :valid,
            :completed,
            organization: organization,
            worker: worker,
            start: Time.current
          )
        }
      end
      let(:cost) { organization.services.sum(:cost) }

      before do
        appointment_proc.call
        travel_to 2.days.ago do
          appointment_proc.call
        end
        travel_to 2.months.ago do
          appointment_proc.call
        end
      end

      it 'returns count of today appointments' do
        expect(subject.text).to match(cost.to_s)
      end

      context 'at the end of month' do
        it 'returns count of today appointments' do
          travel_to Time.current.at_end_of_month do
            expect(subject.text).to match((cost * 2).to_s)
          end
        end
      end
    end
  end

  describe '#call' do
    it 'adds except_ids' do
      expect(subject).to receive(:enqueue)
      expect(subject).to receive(:send)

      subject.call

      expect(subject.except_ids).to eq([worker.id])
    end

    describe '#enqueue' do
      it 'enqueues daily sms job' do
        expect(SmsJob).to receive(:perform_later)
        expect(SmsJob).to receive(:set).and_return(SmsJob)

        subject.call
      end

      context 'with two workers' do
        let!(:second_worker) { create(:worker, :working_all_week, organization: organization) }

        it 'enqueues two sms jobs' do
          expect(SmsJob).to receive(:perform_later)
          expect(SmsJob).not_to receive(:set)

          subject.call
        end
      end
    end

    describe '#send' do
      it 'send sms' do
        expect_any_instance_of(Smsru).to receive(:send)
        expect(subject).to receive(:text)

        subject.send
      end
    end
  end
end
