ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: ENV.fetch("PARALLEL_WORKERS", :number_of_processors)) unless ENV["CI"]

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  Geocoder.configure(lookup: :test, ip_lookup: :test)
  Geocoder::Lookup::Test.reset
end
