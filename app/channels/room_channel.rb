# frozen_string_literal: true

class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'room_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    user = User.find_by(email: data['email'])

    message = Message.new(content: data['content'], user_id: user.id)
    if message.save
      broadcast_message = format_message(message)
      ActionCable.server.broadcast 'room_channel', broadcast_message.merge(type: 'new_message')
    else
      Rails.logger.error "Failed to create message: #{message.errors.full_messages}"
    end
  end

  def broadcast_deleted_message(message_id)
    ActionCable.server.broadcast 'room_channel', { id: message_id, type: 'delete_message' }
  end

  private

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
