# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!, only: %i[index destroy]
  before_action :set_message, only: %i[destroy]
  before_action :authorize_user!, only: %i[destroy]

  def index
    messages = Message.eager_load(:user, :likes).includes(likes: :user).order(created_at: :asc)
    render json: format_messages(messages), status: :ok
  end

  def destroy
    if @message.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete the message' }, status: :internal_server_error
    end
  end

  private

  def set_message
    @message = Message.find_by(id: params[:id])
    render json: { error: 'Message not found' }, status: :not_found unless @message
  end

  def authorize_user!
    render json: { error: 'Forbidden' }, status: :forbidden unless @message.user == current_user
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
