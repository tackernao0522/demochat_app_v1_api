# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  it '有効な属性があれば有効であること' do
    message = build(:message, content: 'これはテストメッセージです。')
    expect(message).to be_valid
  end

  it '内容がなければ無効であること' do
    message = build(:message, content: nil)
    expect(message).to_not be_valid
  end
end
