# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    content { 'これはテストメッセージです。' }
    association :user
  end
end
