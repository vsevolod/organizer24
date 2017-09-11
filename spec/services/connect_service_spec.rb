require 'rails_helper'

RSpec.describe ConnectService do
  describe '.generate!' do
    subject { described_class.generate!(telegram_user, user) }

    let(:telegram_user) { create(:telegram_user) }
    let(:user) { create(:user) }

    it 'updates phone and generate confirmation number' do
      expect { subject }
        .to change { telegram_user.phone }.to(user.phone)
        .and change { telegram_user.confirmation_number }
    end
  end
end
