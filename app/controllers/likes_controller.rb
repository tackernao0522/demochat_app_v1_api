# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!, only: %w[create destroy]
  before_action :set_message, only: :create
  before_action :set_like, only: :destroy

  def create
    return render_not_found_message unless @message

    existing_like = @message.likes.find_by(user: current_user)
    if existing_like
      handle_existing_like(existing_like)
    else
      handle_new_like
    end
  end

  def destroy
    if @like
      @like.destroy
      head :no_content
    else
      render_not_found
    end
  end

  private

  def set_message
    @message = Message.find_by(id: params[:id])
    render_not_found_message unless @message
  end

  def set_like
    @like = current_user.likes.find_by(id: params[:id])
  end

  def handle_existing_like(existing_like)
    if existing_like.destroy
      broadcast_like(@message)
      render json: { id: nil, email: current_user.email, message: 'いいねを削除しました' }, status: :ok
    else
      render_unprocessable_entity(existing_like.errors.messages)
    end
  end

  def handle_new_like
    like = current_user.likes.new(message: @message)
    if like.save
      broadcast_like(@message)
      render json: { id: like.id, email: current_user.email, message: 'いいねが成功しました' }, status: :created
    else
      render_unprocessable_entity(like.errors.messages)
    end
  end

  def render_not_found
    render json: { errors: 'Like not found' }, status: :not_found
  end

  def render_not_found_message
    render json: { errors: 'Message not found' }, status: :not_found
  end

  def render_unprocessable_entity(errors)
    render json: { message: 'いいねの保存が出来ませんでした', errors: }, status: :unprocessable_entity
  end

  def broadcast_like(message)
    message = Message.includes(likes: :user).find(message.id)
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
