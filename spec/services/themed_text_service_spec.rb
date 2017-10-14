require 'rails_helper'

RSpec.describe ThemedTextService do
  describe '#user_notify' do
    let(:appointment) { build(:appointment, :with_worker) }
    let(:template) { 'Test: <ИМЯ>' }

    before do
      appointment.worker.user_notify_text = template
    end

    it 'fills template' do
      expect(subject.user_notify(appointment))
        .to eq("Test: #{appointment.firstname}")
    end
  end
end
