# frozen_string_literal: true

require 'devise'

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Cookies
  include Response
end
