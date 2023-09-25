ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "sidekiq/testing"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: ENV.fetch("PARALLEL_WORKERS", :number_of_processors))

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  Geocoder.configure(lookup: :test, ip_lookup: :test)
  Geocoder::Lookup::Test.reset

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :minitest
      with.library :rails
    end
  end

  # Run Sidekiq jobs immediately (useful for testing `deliver_later` Mailers)
  Sidekiq::Testing.inline!
end
