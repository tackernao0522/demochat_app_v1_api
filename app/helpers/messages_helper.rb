# frozen_string_literal: true

module MessagesHelper
  def format_message(message)
    "#{message.user.name}: #{message.content}"
  end
end
