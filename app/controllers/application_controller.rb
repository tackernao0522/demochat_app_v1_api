# frozen_string_literal: true

require 'devise'

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Cookies
  include Response

  rescue_from StandardError, with: :handle_error

  private

  def handle_error(error)
    logger.error "Error: #{error.message}"
    logger.error error.backtrace.join("\n")
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end
end
