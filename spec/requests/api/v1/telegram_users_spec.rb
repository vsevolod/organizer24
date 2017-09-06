require 'rails_helper'

RSpec.describe API::V1::TelegramUsers do
  describe 'POST /api/v1/telegram_users' do
    let(:attributes) { { telegram_id: 1, username: 'Ivan Petrov' } }
    let(:request) { -> { post '/api/v1/telegram_users', attributes } }

    it 'creates one telegram user' do
      expect { request.call }
        .to change(TelegramUser, :count).by(1)
    end
  end

  describe 'GET /api/v1/telegram_users/:telegram_id' do
    let(:user) { create(:telegram_user) }
    let(:request) { -> { get "/api/v1/telegram_users/#{user.telegram_id}" } }

    it 'show telegram user info' do
      request.call

      expect(response_json.dig('result', 'telegram_id')).to eq(user.telegram_id)
    end
  end
end
