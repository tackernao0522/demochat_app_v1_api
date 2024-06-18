# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  it '有効なファクトリを持つこと' do
    expect(build(:like)).to be_valid
  end

  it 'ユーザーがなければ無効であること' do
    expect(build(:like, user: nil)).to_not be_valid
  end

  it 'メッセージがなければ無効であること' do
    expect(build(:like, message: nil)).to_not be_valid
  end
end
