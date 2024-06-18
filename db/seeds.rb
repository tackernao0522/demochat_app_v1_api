# frozen_string_literal: true

# db/seeds.rb

# ユーザーを作成
user = User.first_or_create!(
  name: 'デフォルトユーザー',
  email: 'default@example.com',
  password: 'password',
  password_confirmation: 'password'
)

if user.persisted?
  Rails.logger.debug { "ユーザーが作成されました: #{user.id}" }
else
  Rails.logger.debug 'ユーザーの作成に失敗しました'
end

# メッセージを作成
3.times do |number|
  message = Message.create!(content: "#{number}番目のメッセージです!", user_id: user.id)
  if message.persisted?
    Rails.logger.debug { "#{number}番目のメッセージが作成されました: #{message.id}" }
  else
    Rails.logger.debug { "#{number}番目のメッセージの作成に失敗しました" }
  end
end

Rails.logger.debug 'メッセージの作成が完了しました'
