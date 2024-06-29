# frozen_string_literal: true

class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'room_channel'
    Rails.logger.info 'User subscribed to RoomChannel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.info 'User unsubscribed from RoomChannel'
  end

  def receive(data)
    Rails.logger.info "Received data: #{data.inspect}"
    user = find_user(data['email'])

    if user
      create_and_broadcast_message(data, user)
    else
      Rails.logger.error "User not found: #{data['email']}"
    end
  end

  private

  def find_user(email)
    User.find_by(email:).tap do |user|
      Rails.logger.error "User not found: #{email}" unless user
    end
  end

  def create_and_broadcast_message(data, user)
    message = Message.create(content: data['message'], user_id: user.id)

    if message.persisted?
      broadcast_message(data, user, message)
    else
      Rails.logger.error "Failed to create message: #{data['message']} for user: #{user.email}"
    end
  end

  def broadcast_message(data, user, message)
    ActionCable.server.broadcast 'room_channel', {
      message: data['message'],
      name: user.name,
      created_at: message.created_at,
      email: user.email
    }
    Rails.logger.info "Broadcast message: #{data['message']} from user: #{user.email}"
  end
end
