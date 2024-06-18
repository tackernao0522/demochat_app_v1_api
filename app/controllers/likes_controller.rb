# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!, only: ['create']

  def create
    like = Like.new(message_id: params[:id], user_id: current_user.id)

    if like.save
      render json: { id: like.id, email: current_user.email, message: '成功しました' }, status: :ok
    else
      render json: { message: '保存出来ませんでした', errors: like.errors.messages }, status: :bad_request
    end
  end
end
