# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.7', '>= 7.0.7.2'

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'

# Use postgresql as the database for Active Record
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem 'tailwindcss-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis'

# Enumerated attributes with I18n and ActiveRecord/Mongoid support
gem 'enumerize'

# AASM - State machines for Ruby classes
gem 'aasm'
gem 'after_commit_everywhere'

# FriendlyId is the "Swiss Army bulldozer" of slugging and permalink plugins for Active Record. It lets you create pretty URLs and work with human-friendly strings as if they were numeric ids.
gem 'friendly_id'

# Simple, but flexible HTTP client library, with support for multiple backends.
gem 'faraday'

# Faraday 1x and 2.x compatible extraction of FaradayMiddleware::FollowRedirects
gem 'faraday-follow_redirects'

# Catches exceptions and retries each request a limited number of times
gem 'faraday-retry'

gem 'ruby-readability', require: 'readability'

# Ruby gem for web scraping purposes.
gem 'metainspector'

# Ruby gem to convert html into markdown
gem 'reverse_markdown'

# Nearest neighbor search for Rails and Postgres
gem 'neighbor'

# Build LLM-backed Ruby applications
gem 'langchainrb', require: 'langchain'
gem 'pgvector'
gem 'ruby-openai'

# Simple, efficient background processing for Ruby
gem 'sidekiq'

# Scheduler / Cron for Sidekiq jobs
gem 'sidekiq-cron'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Annotate Rails classes with schema and routes info
  gem 'annotate', require: false

  # A Ruby static code analyzer and formatter
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
