# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!, only: %w[create destroy]
  before_action :set_like, only: :destroy

  def create
    like = Like.new(message_id: params[:id], user_id: current_user.id)
    render_response(like.save, like, 'いいねが成功しました', 'いいねの保存が出来ませんでした')
  end

  def destroy
    if @like.nil?
      render json: { message: 'いいねが見つかりませんでした' }, status: :not_found
    else
      render_response(@like.destroy, @like, 'いいねの削除に成功しました', 'いいねの削除が出来ませんでした')
    end
  end

  private

  def set_like
    @like = Like.find_by(id: params[:id], user_id: current_user.id)
  end

  def render_response(success, like, success_message, failure_message)
    if success
      render json: { id: like.id, email: current_user.email, message: success_message }, status: :ok
    else
      render json: { message: failure_message, errors: like.errors.messages }, status: :bad_request
    end
  end
end
