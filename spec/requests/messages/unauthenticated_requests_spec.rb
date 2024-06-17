# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /messages 認証なしの場合', type: :request do
  context '認証なしの場合' do
    before { get '/messages' }

    it '401エラーを返すこと' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
