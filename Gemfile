# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.3'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use PostgreSQL as the database for Active Record
gem 'pg', '~> 1.5'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'
gem 'http'

# Inertia.js Rails adapter
gem 'inertia_rails', '~> 3.6'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'dotenv', groups: %i[development test]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Background job processing with Sidekiq
gem 'sidekiq', '~> 7.2'
gem 'sidekiq-cron', '~> 1.12'
gem 'sidekiq-unique-jobs', '~> 8.0'

# Redis for Sidekiq
gem 'redis', '~> 5.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Prettier Ruby formatting (syntax_tree parser required by @prettier/plugin-ruby)
  gem 'syntax_tree', require: false

  # Shopify Ruby Style Guide [https://ruby-style-guide.shopify.dev/]
  gem 'rubocop-shopify', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-sorbet', require: false

  # RSpec for testing
  gem 'rspec-rails', '~> 8.0'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.2'

  # Sorbet type checking
  gem 'sorbet', '~> 0.5.11422', require: false
  gem 'tapioca', '~> 0.13.0', require: false
end

# Sorbet runtime (needed in all environments)
gem 'sorbet-runtime', '~> 0.5.11422'

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 6.0'
end

gem 'ruby_llm', '~> 1.9'
