# frozen_string_literal: true

class BaseApiController < ActionController::API
  include Response

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-CSRF-Token']
  end
end
