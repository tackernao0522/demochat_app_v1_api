# frozen_string_literal: true

# app/controllers/auth/registrations_controller.rb
module Auth
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    private

    def sign_up_params
      params.permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.permit(:name, :email, :password, :password_confirmation, :current_password)
    end
  end
end
