# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes API - POST /messages/:id/likes', type: :request do
  let!(:user) { create(:user) }
  let!(:message) { create(:message, user:) }
  let(:headers) { user.create_new_auth_token }

  context '認証なしの場合' do
    it '401エラーを返すこと' do
      post "/messages/#{message.id}/likes"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context '認証ありの場合' do
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

RSpec.describe 'Likes API - DELETE /likes/:id', type: :request do
  let!(:user) { create(:user) }
  let!(:message) { create(:message, user:) }
  let(:headers) { user.create_new_auth_token }
  let!(:like) { create(:like, user:, message:) }

  context '認証なしの場合' do
    it '401エラーを返すこと' do
      delete "/likes/#{like.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context '認証ありの場合' do
    it 'いいねを削除できること' do
      expect do
        delete "/likes/#{like.id}", headers:
      end.to change(Like, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end

    it '存在しないいいねを削除しようとするとエラーが返されること' do
      expect do
        delete '/likes/0', headers:
      end.to_not change(Like, :count)
      expect(response).to have_http_status(:not_found)
    end
  end
end
