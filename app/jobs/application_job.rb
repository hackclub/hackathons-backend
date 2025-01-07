class ApplicationJob < ActiveJob::Base
  discard_on ActiveJob::DeserializationError # most likely a record that's not there anymore

  include RateLimitable
end
