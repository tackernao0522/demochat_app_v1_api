# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth::Registrations', type: :request do
  describe 'POST /auth' do
    it 'ユーザーが正常に登録されること' do
      post '/auth',
           params: { name: 'テストユーザー', email: 'test@example.com', password: 'password',
                     password_confirmation: 'password' }
      expect(response).to have_http_status(:success)
      expect(json['data']['email']).to eq('test@example.com')
    end

    it 'パスワードが一致しない場合は登録に失敗すること' do
      post '/auth',
           params: { name: 'テストユーザー', email: 'test@example.com', password: 'password',
                     password_confirmation: 'different_password' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']['full_messages']).to include('Password confirmation が一致しません')
    end

    it 'メールアドレスが既に存在する場合は登録に失敗すること' do
      create(:user, email: 'test@example.com')
      post '/auth',
           params: { name: 'テストユーザー', email: 'test@example.com', password: 'password',
                     password_confirmation: 'password' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']['full_messages']).to include('Email はすでに存在します')
    end
  end
end

# レスポンスのJSONをパースするヘルパーメソッド
def json
  response.parsed_body
end
