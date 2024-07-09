# frozen_string_literal: true

module Auth
  class SessionsController < DeviseTokenAuth::SessionsController
    include ActionController::Cookies

    def create
      super do |resource|
        assign_access_token_cookie(resource.create_new_auth_token)
      end
    end

    def destroy
      # ユーザーのロード
      @resource = resource_class.find_by(uid: sign_out_params[:uid])

      if @resource
        # トークンを無効化
        @resource.tokens = {}
        @resource.save

        # クッキーを削除
        delete_cookies

        # セッションをクリア
        sign_out(@resource)

        render json: { success: true }
      else
        render json: { errors: ['User not found'] }, status: :unprocessable_entity
      end
    rescue StandardError => e
      logger.error "Error in SessionsController#destroy: #{e.message}"
      render json: { errors: [e.message] }, status: :internal_server_error
    end

    private

    def assign_access_token_cookie(token)
      cookies[:access_token] = {
        value: token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: Rails.env.production? ? :none : :lax
      }
    end

    def delete_cookies
      if Rails.env.production?
        cookies.delete(:access_token, domain: '.fly.dev', same_site: :none, secure: true)
        cookies.delete(:access_token, domain: '.vercel.app', same_site: :none, secure: true)
      else
        cookies.delete(:access_token, domain: 'localhost')
      end
    end

    def sign_out_params
      params.require(:auth).permit(:uid)
    end
  end
end
