source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.0.beta3"
gem "bcrypt", "3.1.18"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 1.4"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"
gem "faker", "2.21.0"
gem "will_paginate", "3.3.1"
gem "bootstrap-will_paginate", "1.0.0"
gem "sass-rails"
gem "rexml", ">= 3.3.6"
gem 'faraday'
gem "chartkick"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem 'simplecov'
  gem 'rspec-rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  gem "capybara", "3.37.1"
  gem "selenium-webdriver", "4.2.0"
  gem "webdrivers", "5.0.0"
  gem "rails-controller-testing", "1.0.5"
  gem "minitest", "5.15.0"
  gem "minitest-reporters", "1.5.0"
  gem "guard", "2.18.0"
  gem "guard-minitest", "2.4.6"
  gem "factory_bot_rails"
end
