# frozen_string_literal: true

module Auth
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    private

    def sign_up_params
      if params[:registration]
        params.require(:registration).permit(:name, :email, :password, :password_confirmation)
      else
        params.permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
