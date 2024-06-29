# app/channels/room_channel.rb
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{current_user.id}"
    Rails.logger.info "User #{current_user.email} subscribed to RoomChannel"
  end

  def unsubscribed
    Rails.logger.info "User #{current_user.email} unsubscribed from RoomChannel"
  end

  def receive(data)
    Rails.logger.info "Received data: #{data.inspect}"

    if data['message'].present?
      create_and_broadcast_message(data, current_user)
    else
      Rails.logger.error "Received empty message from user: #{current_user.email}"
    end
  end

  private

  def create_and_broadcast_message(data, user)
    message = Message.create(content: data['message'], user_id: user.id)

    if message.persisted?
      broadcast_message(data, user, message)
    else
      Rails.logger.error "Failed to create message: #{data['message']} for user: #{user.email}"
    end
  end

  def broadcast_message(data, user, message)
    ActionCable.server.broadcast "room_channel_#{user.id}", {
      message: data['message'],
      name: user.name,
      created_at: message.created_at,
      email: user.email
    }
    Rails.logger.info "Broadcast message: #{data['message']} from user: #{user.email}"
  end
end
