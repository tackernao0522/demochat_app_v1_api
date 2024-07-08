module Auth
  class SessionsController < DeviseTokenAuth::SessionsController
    include ActionController::Cookies

    def create
      super do |resource|
        assign_access_token_cookie(resource.create_new_auth_token)
      end
    end

    def destroy
      # トークンを無効化
      @resource.tokens = {}
      @resource.save

      # クッキーを削除
      cookies.delete(:access_token, domain: :all, same_site: :none, secure: true)

      # セッションをクリア
      sign_out(@resource)

      render json: { success: true }
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
  end
end
