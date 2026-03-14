require "test_helper"

class RateLimitableTest < ActiveJob::TestCase
  setup do
    @previous_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    RateLimitWindow.delete_all
  end

  teardown do
    ActiveJob::Base.queue_adapter = @previous_queue_adapter
    RateLimitWindow.delete_all
  end

  class RateLimitedJob < ApplicationJob
    rate_limit to: 3, within: 1.minute

    def perform
    end
  end

  class ExtendedWaitJob < ApplicationJob
    rate_limit to: 3, within: 1.minute,
      extend_wait: {on: [Faraday::TimeoutError], for: 2.minutes}

    def perform
      raise Faraday::TimeoutError, "open timeout"
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
    assert_no_enqueued_jobs
  end

  test "extending wait for configured errors" do
    assert_enqueued_jobs 1, only: ExtendedWaitJob do
      ExtendedWaitJob.perform_now
    end

    assert_operator RateLimitWindow.remaining_wait_time("RateLimitableTest::ExtendedWaitJob"), :>, 100
  end
end
