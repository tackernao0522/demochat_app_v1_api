# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  let(:user) { create(:user) }
  let!(:message) { create(:message, user:) } # ここで message を定義
  let(:headers) { user.create_new_auth_token }

  describe 'DELETE /messages/:id' do
    context '認証なしの場合' do
      it '401エラーを返すこと' do
        delete "/messages/#{message.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context '認証ありの場合' do
      context '自分のメッセージを削除する場合' do
        it 'メッセージを削除できること' do
          expect do
            delete "/messages/#{message.id}", headers:
          end.to change(Message, :count).by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end
end
