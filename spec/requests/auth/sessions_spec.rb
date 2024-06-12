# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth::Sessions', type: :request do
  describe 'POST /auth/sign_in' do
    let(:user) { create(:user) }

    it 'ユーザーが正常にログインできること' do
      post '/auth/sign_in',
           params: { email: user.email, password: user.password }
      expect(response).to have_http_status(:success)
      expect(json['data']['email']).to eq('test@example.com')
    end

    it '無効なパスワードでログインに失敗すること' do
      post '/auth/sign_in', params: { email: user.email, password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /auth/sign_out' do
    let(:user) { create(:user) }

    it 'ユーザーが正常にログアウトできること' do
      post '/auth/sign_in', params: { email: user.email, password: user.password }
      token = response.headers['access-token']
      client = response.headers['client']
      uid = response.headers['uid']

      delete '/auth/sign_out', headers: { 'access-token' => token, 'client' => client, 'uid' => uid }
      expect(response).to have_http_status(:success)
    end
  end
end

def json
  response.parsed_body
end
