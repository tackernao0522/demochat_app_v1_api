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
      super do |_resource|
        cookies.delete(:access_token)
      end
    end

    private

    def assign_access_token_cookie(token)
      cookies[:access_token] = {
        value: token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict
      }
    end
  end
end
