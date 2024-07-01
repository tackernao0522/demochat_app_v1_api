# frozen_string_literal: true

class ApplicationController < BaseApiController
  include DeviseTokenAuth::Concerns::SetUserByToken
end
