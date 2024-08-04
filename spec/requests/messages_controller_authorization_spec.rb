# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages API Authorization', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:headers) { user.create_new_auth_token }

  describe 'DELETE /messages/:id' do
    context '認証ありの場合' do
      context '他のユーザーのメッセージを削除しようとする場合' do
        let!(:other_message) { create(:message, user: other_user) }

        it '403エラーを返すこと' do
          delete("/messages/#{other_message.id}", headers:)
          expect(response).to have_http_status(:forbidden)
        end
      end

      context '存在しないメッセージを削除しようとする場合' do
        it '404エラーを返すこと' do
          delete('/messages/999999', headers:)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
