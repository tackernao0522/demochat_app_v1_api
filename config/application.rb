# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 7.0

    # セッションミドルウェアを追加
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # CSRFトークンの設定
    config.middleware.use ActionDispatch::Flash
    config.api_only = false
  end
end
