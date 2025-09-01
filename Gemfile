# frozen_string_literal: true

source "https://rubygems.org"

gem "bootsnap", require: false
gem "importmap-rails"
gem "jbuilder"
gem "kamal", require: false
gem "pg", "~> 1.1"
gem "propshaft"
gem "puma", ">= 5.0"
gem "rails", github: "rails/rails", branch: "8-0-stable"
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "faker", "~> 3.5"
  gem "pry-rails", "~> 0.3.11"
  gem "bullet", "~> 8.0"
end

group :development do
  gem "annotaterb"
  gem "letter_opener"
  gem "rack-mini-profiler"
  gem "rubocop", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "web-console"
  gem "shog", "~> 0.2.1"
  gem "rails_performance", "~> 1.5"
  gem "meta_request", "~> 0.8.5"
end

group :test do
  gem "capybara", require: false
  gem "selenium-webdriver", require: false
  gem "shoulda-matchers"
end

gem "view_component", "~> 4.0"


gem "pagy", "~> 9.4"

gem "authentication-zero", "~> 4.0"
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"
# Use OmniAuth to support multi-provider authentication [https://github.com/omniauth/omniauth]
gem "omniauth"
# Provides a mitigation against CVE-2015-9284 [https://github.com/cookpad/omniauth-rails_csrf_protection]
gem "omniauth-rails_csrf_protection"

gem "omniauth-google-oauth2", "~> 1.2"

gem "omniauth-facebook", "~> 10.0"

gem "omniauth-twitter", "~> 1.4"

gem "omniauth-linkedin-oauth2", "~> 1.0"
gem "avo", ">= 3.17"
gem "dotenv", groups: [:development, :test]
