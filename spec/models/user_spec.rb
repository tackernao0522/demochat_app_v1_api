# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it '有効な属性があれば有効であること' do
    user = build(:user, name: 'テストユーザー', email: 'test@example.com')
    expect(user).to be_valid
  end

  it '名前がなければ無効であること' do
    user = build(:user, name: nil)
    expect(user).to_not be_valid
  end

  it 'メールアドレスがなければ無効であること' do
    user = build(:user, email: nil)
    expect(user).to_not be_valid
  end

  it '重複したメールアドレスがある場合は無効であること' do
    create(:user, email: 'test@example.com')
    user = build(:user, email: 'test@example.com')
    expect(user).to_not be_valid
  end
end
