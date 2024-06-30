# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    # Connect the simulated user to the channel
    stub_connection current_user: user
  end

  describe 'サブスクライブとストリーム' do
    it 'チャンネルにサブスクライブするとストリームに登録される' do
      subscribe
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from('room_channel')
    end

    it 'サブスクリプションを解除するとストリームが解除される' do
      subscribe
      expect(subscription).to be_confirmed
      subscription.unsubscribe_from_channel
      expect(subscription).to_not have_stream_from('room_channel')
    end
  end
end
