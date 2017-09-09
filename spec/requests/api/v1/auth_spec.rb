require 'rails_helper'

RSpec.describe API::V1::Auth do
  describe 'POST /api/v1/:telegram_id/sign_in' do
    let(:params) { { username: 'Ivan Petrov' } }
    let(:telegram_id) { SecureRandom.rand(10000) }
    let(:request) { -> { post "/api/v1/#{telegram_id}/sign_in", params: params } }

    context 'new user' do
      it 'creates one telegram user' do
        expect { request.call }.to change(TelegramUser, :count).by(1)

        expect(response_json.dig('result', 'telegram_id')).to eq(telegram_id)
      end
    end

    context 'already exist user' do
      let!(:user) { create(:telegram_user, telegram_id: telegram_id) }
      it 'does not create telegram user' do
        expect { request.call }.not_to change(TelegramUser, :count)

        expect(response_json.dig('result', 'telegram_id')).to eq(telegram_id)
      end
    end
  end
end
