# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes API', type: :request do
  let!(:user) { create(:user) }
  let!(:message) { create(:message, user:) }
  let(:headers) { user.create_new_auth_token }

  describe 'POST /messages/:id/likes' do
    context '認証なしの場合' do
      it '401エラーを返すこと' do
        post "/messages/#{message.id}/likes"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

RSpec.describe 'Likes API with authentication', type: :request do
  let!(:user) { create(:user) }
  let!(:message) { create(:message, user:) }
  let(:headers) { user.create_new_auth_token }

  describe 'POST /messages/:id/likes' do
    context '認証ありの場合'
    it 'メッセージにいいねを作成できること' do
      expect do
        post "/messages/#{message.id}/likes", headers:
      end.to change(Like, :count).by(1)
      expect(response).to have_http_status(:ok)
    end

    it '同じメッセージに複数回いいねを作成しようとするとエラーが返されること' do
      post("/messages/#{message.id}/likes", headers:)
      expect do
        post "/messages/#{message.id}/likes", headers:
      end.to_not change(Like, :count)
      expect(response).to have_http_status(:bad_request)
    end
  end
end
