# frozen_string_literal: true

module Auth
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    def create
      super do |resource|
        if resource.persisted?
          Rails.logger.info("User #{resource.email} was successfully registered.")
        else
          Rails.logger.error("User registration failed: #{resource.errors.full_messages}")
        end
      end
    end

    private

    def sign_up_params
      params.permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.permit(:name, :email, :password, :password_confirmation, :current_password)
    end
  end
end
