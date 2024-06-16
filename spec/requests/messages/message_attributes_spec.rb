# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /messages メッセージの内容が正しいこと', type: :request do
  let!(:user) { create(:user) }
  let!(:messages) { create_list(:message, 5, user:) }
  let(:headers) { user.create_new_auth_token }

  before { get '/messages', params: { headers: } }
  let(:json) { response.parsed_body }

  it 'メッセージがJSON形式で返されること' do
    expect(json).not_to be_empty
    expect(json.size).to eq(5)
  end

  it '各メッセージの属性が正しいこと' do
    json.each_with_index do |message, index|
      expect(message['id']).to eq(messages[index].id)
      expect(message['user_id']).to eq(user.id)
      expect(message['name']).to eq(user.name)
      expect(message['content']).to eq(messages[index].content)
      expect(message['email']).to eq(user.email)
      expect(message['created_at']).to eq(messages[index].created_at.as_json)
    end
  end
end
