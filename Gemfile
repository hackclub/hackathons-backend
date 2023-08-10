source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "dotenv-rails"

gem "rails", "~> 7.0.6"

# Drivers
gem "pg"
gem "puma"
gem "redis"

gem "airrecord" # Airtable client

# Assets
gem "sprockets-rails"
gem "sass-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "local_time"
gem "premailer-rails" # Inline CSS for emails

# Active Storage
gem "aws-sdk-s3", require: false
gem "image_processing", ">= 1.2"
gem "active_storage_validations"

# Background jobs
gem "sidekiq"
gem "sidekiq-cron"

# API
gem "jbuilder" # JSON templating
gem "versioncake" # API versioning

gem "pagy" # Pagination

# Geography
gem "geocoder"
gem "countries"

gem "hashid-rails" # Non-sequential IDs

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby] # Windows doesn't include zoneinfo files
gem "bootsnap", require: false # reduces boot times through caching; required in config/boot.rb

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # Code Critics
  gem "standard"
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "letter_opener_web"

  gem "spring"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda"
end
