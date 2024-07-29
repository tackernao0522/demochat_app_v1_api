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
      if @resource
        invalidate_token_and_clear_session
        render json: { success: true }
      else
        render_not_logged_in
      end
    rescue StandardError => e
      handle_destroy_error(e)
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

    def invalidate_token_and_clear_session
      invalidate_resource_tokens
      clear_session_cookies
      clear_devise_token_auth_headers
      sign_out(@resource)
    end

    def invalidate_resource_tokens
      @resource.tokens = {}
      @resource.save
    end

    def clear_session_cookies
      cookies_to_delete = [:access_token, :_session_id, 'user.expires_at', 'user.id']
      cookies_to_delete.each do |cookie_name|
        delete_cookie(cookie_name)
      end
    end

    def delete_cookie(name)
      cookies.delete(name, domain: :all, same_site: :none, secure: true)
    end

    def clear_devise_token_auth_headers
      response.headers['access-token'] = nil
      response.headers['client'] = nil
      response.headers['uid'] = nil
    end

    def render_not_logged_in
      render json: { errors: ['Not logged in'] }, status: :not_found
    end

    def handle_destroy_error(error)
      logger.error "Error in SessionsController#destroy: #{error.message}"
      render json: { errors: [error.message] }, status: :internal_server_error
    end
  end
end
