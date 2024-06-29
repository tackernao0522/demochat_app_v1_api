# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    # Connect the simulated user to the channel
    stub_connection current_user: user
  end

  it 'チャンネルにサブスクライブするとストリームに登録される' do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("room_channel_#{user.id}")
  end

  it 'メッセージをストリームにブロードキャストする' do
    subscribe
    expect do
      perform :receive, { message: 'こんにちは', email: user.email }
    end.to have_broadcasted_to("room_channel_#{user.id}").with(hash_including(
                                                                 message: 'こんにちは',
                                                                 name: user.name,
                                                                 created_at: be_present
                                                               ))
  end

  it 'サブスクリプションを解除するとストリームが解除される' do
    subscribe
    expect(subscription).to be_confirmed
    subscription.unsubscribe_from_channel
    expect(subscription).to_not have_stream_from("room_channel_#{user.id}")
  end
end
