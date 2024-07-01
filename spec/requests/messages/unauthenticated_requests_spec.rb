# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /messages 認証なしの場合', type: :request do
  context '認証なしの場合' do
    before { get '/messages' }

    it '302リダイレクトが返されること' do
      expect(response).to have_http_status(:found)
    end

    it 'ログインページへのリダイレクトであること' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
