# frozen_string_literal: true

# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!, only: %i[index create update destroy]
  before_action :set_message, only: %i[update destroy]

  def index
    messages = Message.all
    render json: format_messages(messages), status: :ok
  end

  def create
    message = current_user.messages.build(message_params)
    if message.save
      ActionCable.server.broadcast 'room_channel', format_message(message)
      render json: format_message(message), status: :created
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  def update
    if @message.update(message_params)
      render json: format_message(@message)
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy
    head :no_content
  end

  private

  def set_message
    @message = current_user.messages.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

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
