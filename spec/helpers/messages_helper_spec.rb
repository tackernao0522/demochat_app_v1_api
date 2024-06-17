# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesHelper, type: :helper do
  describe '#format_message' do
    let(:user) { build(:user, name: 'テストユーザー') }
    let(:message) { build(:message, content: 'これはテストメッセージです。', user:) }

    it 'メッセージをフォーマットすること' do
      result = helper.format_message(message)
      expect(result).to eq('テストユーザー: これはテストメッセージです。')
    end
  end
end
