# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /messages いいね情報が正しいこと', type: :request do
  let!(:user) { create(:user) }
  let!(:messages) { create_list(:message, 5, user:) }
  let!(:like) { create(:like, user:, message: messages.first) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:json) { response.parsed_body['data'] }

  before do
    sign_in user
    get '/messages', headers: auth_headers
  end

  it 'いいね情報が正しいこと' do
    message = json.find { |msg| msg['id'] == messages.first.id }
    expect(message['likes']).to be_an_instance_of(Array)
    expect(message['likes'].first['id']).to eq(like.id)
    expect(message['likes'].first['email']).to eq(user.email)
  end
end
