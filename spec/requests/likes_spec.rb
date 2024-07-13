# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Likes API', type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:message) { create(:message, user:) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:another_auth_headers) { another_user.create_new_auth_token }

  describe 'POST /messages/:id/likes' do
    context '認証なしの場合' do
      it '401エラーを返すこと' do
        post "/messages/#{message.id}/likes"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context '認証ありの場合' do
      it 'メッセージにいいねを作成できること' do
        expect do
          post "/messages/#{message.id}/likes", headers: auth_headers
        end.to change(Like, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it '既存のいいねを削除できること' do
        post "/messages/#{message.id}/likes", headers: auth_headers
        expect do
          post "/messages/#{message.id}/likes", headers: auth_headers
        end.to change(Like, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end

      it '同じメッセージに対する複数の「いいね」リクエストを処理できること' do
        5.times do
          post "/messages/#{message.id}/likes", headers: auth_headers
          expect(response).to have_http_status(:created).or(have_http_status(:ok))
        end
      end

      it '存在しないメッセージに対する「いいね」リクエストで404エラーを返すこと' do
        post '/messages/0/likes', headers: auth_headers
        expect(response).to have_http_status(:not_found)
      end

      it '複数のユーザーが同じメッセージに「いいね」できること' do
        post "/messages/#{message.id}/likes", headers: auth_headers
        expect(response).to have_http_status(:created)

        post "/messages/#{message.id}/likes", headers: another_auth_headers
        expect(response).to have_http_status(:created).or(have_http_status(:ok))
      end

      it '他のユーザーの「いいね」を削除しようとすると404エラーを返すこと' do
        like = create(:like, user: another_user, message:)
        delete "/likes/#{like.id}", headers: auth_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /likes/:id' do
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
          delete "/likes/#{like.id}", headers: auth_headers
        end.to change(Like, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end

      it '存在しないいいねを削除しようとするとエラーが返されること' do
        expect do
          delete '/likes/0', headers: auth_headers
        end.to_not change(Like, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
