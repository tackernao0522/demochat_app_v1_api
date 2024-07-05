# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

require 'devise'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 7.0

    # Middleware
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # Uncomment the line below if you need to use Flash middleware
    # config.middleware.use ActionDispatch::Flash

    # Ensure all autoload paths are correct
    config.eager_load_paths += %W[#{config.root}/lib]

    config.api_only = true

    # Add middleware for handling sessions
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_namespace_key'
  end
end
