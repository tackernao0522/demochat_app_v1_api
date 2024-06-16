# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /messages', type: :request do
  let!(:user) { create(:user) }
  let!(:messages) { create_list(:message, 5, user:) }
  let(:headers) { user.create_new_auth_token }

  before { get '/messages', params: { headers: } }

  it 'リクエストが成功すること' do
    expect(response).to have_http_status(:ok)
  end
end
