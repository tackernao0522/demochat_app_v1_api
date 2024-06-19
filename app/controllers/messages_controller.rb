# frozen_string_literal: true

# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!, only: ['index']

  def index
    messages = Message.all
    render json: format_messages(messages), status: :ok
  end

  private

  def format_messages(messages)
    messages.map { |message| format_message(message) }
  end

  def format_message(message)
    {
      id: message.id,
      user_id: message.user.id,
      name: message.user.name,
      content: message.content,
      email: message.user.email,
      created_at: message.created_at,
      likes: message.likes.map { |like| { id: like.id, email: like.user.email } }
    }
  end
end
