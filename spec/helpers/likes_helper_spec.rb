# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LikesHelper. For example:
#
# describe LikesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe LikesHelper, type: :helper do
  describe '#like_count_message' do
    it '正しい言い値の数を返すこと' do
      likes = [double('Like'), double('Like')]
      expect(helper.like_count_message(likes)).to eq('2 likes')
    end

    it 'いいねがない場合に0 likesを返すこと' do
      likes = []
      expect(helper.like_count_message(likes)).to eq('0 likes')
    end
  end
end
