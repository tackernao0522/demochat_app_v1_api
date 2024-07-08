Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://front-sigma-three.vercel.app'
    resource '*',
             headers: :any,
             expose: %w[access-token expiry token-type uid client],
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end
