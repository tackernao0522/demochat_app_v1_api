# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MessagesHelper. For example:
#
# describe MessagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
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
