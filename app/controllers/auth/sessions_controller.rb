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
      @resource.tokens = {}
      @resource.save
      cookies.delete(:access_token, domain: :all, same_site: :none, secure: true)
      sign_out(@resource)
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
