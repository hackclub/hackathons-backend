require "test_helper"

class RateLimitableTest < ActiveJob::TestCase
  setup do
    ActiveJob::Base.queue_adapter = :test
  end

  teardown do
    ActiveJob::Base.queue_adapter = :inline
  end

  class RateLimitedJob < ApplicationJob
    rate_limit to: 3, within: 1.minute

    def perform
    end
  end

  test "executing jobs within the limit" do
    assert_no_enqueued_jobs do
      3.times { RateLimitedJob.perform_now }
    end
  end

  test "exceeding the rate limit" do
    assert_enqueued_jobs 2, only: RateLimitedJob do
      5.times { RateLimitedJob.perform_now }
    end

    travel 30.seconds, with_usec: true
    perform_enqueued_jobs at: Time.now
    assert_enqueued_jobs 2, only: RateLimitedJob

    travel 30.seconds, with_usec: true
    perform_enqueued_jobs at: Time.now
    assert_no_enqueued_jobs only: RateLimitedJob
  end
end
