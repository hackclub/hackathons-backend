source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

gem "rails", github: "rails/rails"

gem "dotenv-rails", require: "dotenv/load"

# Drivers
gem "pg"
gem "puma"

# Assets
gem "sprockets-rails"
gem "tailwindcss-rails"
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
gem "solid_queue"
gem "mission_control-jobs"

# API
gem "jbuilder" # JSON templating
gem "versioncake" # API versioning
gem "rack-cors" # Cross-origin resource sharing
gem "faraday" # GET / POST requests
gem "faraday-follow_redirects"

gem "geared_pagination"

# User interface
gem "simple_form"
gem "country_select"

# Geography
gem "geocoder"
gem "aws-sdk-locationservice"
gem "countries"

gem "hashid-rails" # Non-sequential IDs

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby] # Windows doesn't include zoneinfo files
gem "bootsnap", require: false # reduces boot times through caching; required in config/boot.rb

gem "appsignal"
gem "lograge"

gem "console1984"
gem "audits1984"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # Code Critics
  gem "standard"
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "letter_opener_web"
  gem "better_errors"
  gem "binding_of_caller" # used by better_errors
end

group :test do
  gem "webmock"

  gem "capybara"
  gem "cuprite"
end
