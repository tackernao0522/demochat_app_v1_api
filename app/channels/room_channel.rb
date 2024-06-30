# frozen_string_literal: true

class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'room_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    user = find_user(data['email'])
    return unless user

    message = create_message(data['message'], user)
    return unless message

    broadcast_message(message)
  end

  private

  def find_user(email)
    user = User.find_by(email:)
    ActionCable.server.broadcast 'room_channel', { error: 'User not found' } unless user
    user
  end

  def create_message(content, user)
    message = Message.new(content:, user:)
    unless message.save
      ActionCable.server.broadcast 'room_channel', { error: message.errors.full_messages.join(', ') }
      return nil
    end
    message
  end

  def broadcast_message(message)
    ActionCable.server.broadcast 'room_channel', format_message(message)
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
