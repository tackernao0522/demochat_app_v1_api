# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /messages メッセージの内容が正しいこと', type: :request do
  let!(:user) { create(:user) }
  let!(:messages) { create_list(:message, 5, user:) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:json) { response.parsed_body['data'] }

  before do
    sign_in user
    get '/messages', headers: auth_headers
  end

  it 'リクエストが成功すること' do
    expect(response).to have_http_status(:ok)
  end

  it 'メッセージがJSON形式で返されること' do
    expect(json.size).to eq(5)
  end
end
