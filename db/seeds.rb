# frozen_string_literal: true

3.times do |number|
  Message.create(content: "#{number}番目のメッセージです!", user_id: User.first.id)
  Rails.logger.debug { "#{number}番目のメッセージを作成しました" }
end

Rails.logger.debug 'メッセージの作成が完了しました'
