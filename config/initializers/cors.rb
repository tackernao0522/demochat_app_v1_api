# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins = ['https://front-sigma-three.vercel.app']
    origins << ENV['API_DOMAIN'] if ENV['API_DOMAIN'].present?

    origins origins.compact.uniq

    resource '*',
             headers: :any,
             expose: %w[access-token expiry token-type uid client],
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end
