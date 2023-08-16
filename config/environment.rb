# Load the Rails application.
require_relative "application"

# Use AppSignal's logger
Rails.logger = ActiveSupport::TaggedLogging.new(Appsignal::Logger.new("rails"))

# Initialize the Rails application.
Rails.application.initialize!
