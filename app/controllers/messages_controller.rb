# frozen_string_literal: true

class MessagesController < BaseApiController
  before_action :authenticate_user!, only: %i[index create update destroy]
  before_action :set_message, only: %i[update destroy]

  def index
    messages = Message.all
    render_success(format_messages(messages))
  end

  def create
    message = current_user.messages.build(message_params)
    if message.save
      ActionCable.server.broadcast 'room_channel', format_message(message)
      render_success(format_message(message), 'メッセージが作成されました', :created)
    else
      render_error('メッセージの作成に失敗しました', message.errors, :unprocessable_entity)
    end
  end

  def update
    if @message.update(message_params)
      render_success(format_message(@message), 'メッセージが更新されました')
    else
      render_error('メッセージの更新に失敗しました', @message.errors, :unprocessable_entity)
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
