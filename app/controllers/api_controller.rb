# frozen_string_literal: true

class ApiController < ApplicationController
  def your_action
    render json: { message: 'Hello from your API endpoint' }
  end
end
