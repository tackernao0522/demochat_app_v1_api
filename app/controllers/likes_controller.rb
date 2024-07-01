# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!, only: %w[create destroy]
  before_action :set_like, only: :destroy

  def create
    like = Like.new(message_id: params[:id], user_id: current_user.id)
    if like.save
      render_success({ id: like.id, email: current_user.email }, 'いいねが成功しました')
    else
      render_error('いいねの保存が出来ませんでした', like.errors, :unprocessable_entity)
    end
  end

  def destroy
    if @like.nil?
      render_error('いいねが見つかりませんでした', {}, :not_found)
    elsif @like.destroy
      render_success({}, 'いいねの削除に成功しました')
    else
      render_error('いいねの削除が出来ませんでした', @like.errors, :unprocessable_entity)
    end
  end

  private

  def set_like
    @like = Like.find_by(id: params[:id], user_id: current_user.id)
  end
end
