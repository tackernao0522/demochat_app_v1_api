# spec/channels/room_channel_broadcast_spec.rb
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    # Connect the simulated user to the channel
    stub_connection current_user: user
  end

  describe 'メッセージのブロードキャスト' do
    it 'メッセージをストリームにブロードキャストする' do
      subscribe
      expect do
        perform :receive, { message: 'こんにちは', email: user.email }
      end.to have_broadcasted_to('room_channel').with(hash_including(
                                                        'content' => 'こんにちは',
                                                        'name' => user.name,
                                                        'email' => user.email,
                                                        'id' => be_present,
                                                        'created_at' => be_present
                                                      ))
    end
  end
end
