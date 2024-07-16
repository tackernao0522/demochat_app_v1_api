# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

gem 'devise', '~> 4.9', '>= 4.9.4'
gem 'devise_token_auth', '~> 1.2.3'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Add missing gems that will no longer be part of the default gems in Ruby 3.4.0
gem 'base64'
gem 'bigdecimal'
gem 'drb'
gem 'mutex_m'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'action-cable-testing', '~> 0.6.1'
  gem 'database_cleaner-active_record'
  gem 'faker'
end

group :development do
  gem 'bullet'
  gem 'irb', '1.10.0'
  gem 'repl_type_completor', '0.1.2'
  gem 'rubocop'
  gem 'rubocop-rails', require: false
  gem 'ruby-lsp'
  gem 'solargraph', '0.50.0'
  gem 'web-console', '4.2.0'
end
