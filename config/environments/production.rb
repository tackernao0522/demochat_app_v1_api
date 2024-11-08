# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

# rubocop:disable Metrics/BlockLength
Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.active_storage.service = :local

  ActionCable.server.config.disable_request_forgery_protection = true
  config.action_cable.url = 'wss://demochat-api.fly.dev/cable'
  config.action_cable.allowed_request_origins = ['https://front-sigma-three.vercel.app']

  config.force_ssl = true
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.cache_store = :file_store, Rails.root.join('tmp/cache/').to_s
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.log_formatter = Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  # CSRF 保護の設定
  config.action_controller.allow_forgery_protection = true
  config.action_controller.forgery_protection_origin_check = true

  # CORS 設定
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'https://front-sigma-three.vercel.app'
      resource '*',
               headers: :any,
               expose: %w[access-token expiry token-type uid client],
               methods: %i[get post put patch delete options head],
               credentials: true
    end
  end

  # Cookie の設定
  config.action_dispatch.cookies_same_site_protection = :none
  config.action_dispatch.cookies_serializer = :json

  # ログの詳細設定
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new($stdout))
  config.logger.level = Logger::DEBUG
end
# rubocop:enable Metrics/BlockLength
