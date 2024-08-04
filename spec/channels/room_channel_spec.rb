# frozen_string_literal: true

# spec/channels/room_channel_spec.rb
require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe RoomChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    # Connect the simulated user to the channel
    stub_connection current_user: user
  end

  it 'チャンネルにサブスクライブするとストリームに登録される' do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('room_channel')
  end

  it 'メッセージをストリームにブロードキャストする' do
    subscribe
    expect do
      perform :receive, { content: 'こんにちは', email: user.email }
    end.to have_broadcasted_to('room_channel').with(hash_including(
                                                      content: 'こんにちは',
                                                      name: user.name,
                                                      created_at: be_present
                                                    ))
  end

  it 'サブスクリプションを解除するとストリームが解除される' do
    subscribe
    expect(subscription).to be_confirmed
    subscription.unsubscribe_from_channel
    expect(subscription).to_not have_stream_from('room_channel')
  end

  it 'メッセージの削除をブロードキャストする' do
    subscribe

    message = create(:message, user:)
    channel = RoomChannel.new(connection, { current_user: user })

    expect do
      channel.send(:broadcast_deleted_message, message.id)
    end.to have_broadcasted_to('room_channel').with(id: message.id, type: 'delete_message')
  end
end
# rubocop:enable Metrics/BlockLength
