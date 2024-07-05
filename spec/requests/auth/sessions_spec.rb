# frozen_string_literal: true

RSpec.describe 'Auth::Sessions', type: :request do
  describe 'DELETE /auth/sign_out' do # ここは '/auth/sign_out' のままで良い
    context 'ユーザーがログインしていない場合' do
      it '404ステータスを返すこと' do # 401ではなく404を期待
        delete '/auth/sign_out'
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'ユーザーがログインしている場合' do
      let(:user) { create(:user) }
      let(:auth_headers) { user.create_new_auth_token }

      before do
        @headers = auth_headers
      end

      it '200ステータスを返すこと' do
        delete '/auth/sign_out', headers: @headers
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
