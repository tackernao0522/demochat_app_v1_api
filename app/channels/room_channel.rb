# frozen_string_literal: true

class RoomChannel < ApplicationCable::Channel
  def subscribed
    user = find_verified_user
    if user
      stream_from "room_channel_#{user.id}"
      Rails.logger.info "User #{user.email} subscribed to RoomChannel"
    else
      reject
      Rails.logger.error 'Subscription rejected: Unauthorized user'
    end
  end

  def unsubscribed
    user = find_verified_user
    if user
      Rails.logger.info "User #{user.email} unsubscribed from RoomChannel"
    else
      Rails.logger.error 'Unsubscription error: Unauthorized user'
    end
  end

  def receive(data)
    Rails.logger.info "Received data: #{data.inspect}"
    user = find_verified_user

    if user
      process_received_data(data, user)
    else
      Rails.logger.error 'Receive error: Unauthorized user'
    end
  end

  private

  def find_verified_user
    if (verified_user = User.find_by(id: current_user&.id))
      verified_user
    else
      Rails.logger.error 'User not found or unauthorized'
      nil
    end
  end

  def process_received_data(data, user)
    if data['message'].present?
      create_and_broadcast_message(data, user)
    else
      Rails.logger.error "Received empty message from user: #{user.email}"
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
    ActionCable.server.broadcast "room_channel_#{user.id}", {
      message: data['message'],
      name: user.name,
      created_at: message.created_at,
      email: user.email
    }
    Rails.logger.info "Broadcast message: #{data['message']} from user: #{user.email}"
  end
end
