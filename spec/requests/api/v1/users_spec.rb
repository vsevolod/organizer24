require 'rails_helper'

RSpec.describe API::V1::Users do
  describe 'POST /api/v1/:telegram_id/users/connect' do
    let(:phone) { '+78002000600' }
    let(:params) { { phone: phone } }
    let(:telegram_id) { SecureRandom.rand(10000) }
    let(:request) { -> { post "/api/v1/#{telegram_id}/users/connect", params: params } }

    let!(:current_user) { create(:telegram_user, telegram_id: telegram_id) }

    context 'existing user with phone' do
      let!(:user) { create(:user, phone: phone) }

      it 'connects with user' do
        post "/api/v1/#{telegram_id}/users/connect", params: params 

        expect { request.call }
          .to change { current_user.reload.phone }.by(phone)

        expect(response_json.dig('result', 'confirmation_number')).not_to be_empty
      end
    end

    context 'user with phone does not exist' do
      it 'does not connects with user' do
        request.call

        expect(response_json.dig('code')).to eq('not_found')
      end
    end
  end
end
