require "test_helper"

class RateLimitableTest < ActiveJob::TestCase
  setup do
    @previous_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
  end

  teardown do
    ActiveJob::Base.queue_adapter = @previous_queue_adapter
  end

  class RateLimitedJob < ApplicationJob
    rate_limit to: 3, within: 1.minute

    def perform
    end
  end

  class ExtendedWaitJob < ApplicationJob
    rate_limit to: 1, within: 1.minute, max_retries: 1,
      extend_wait: {on: Faraday::TimeoutError, for: 2.minutes}

    def perform(raise_error: false)
      raise Faraday::TimeoutError if raise_error
    end
  end

  test "executing jobs under the limit" do
    assert_no_enqueued_jobs do
      3.times { RateLimitedJob.perform_now }
    end
  end

  test "rescheduling jobs exceeding the limit" do
    3.times { RateLimitedJob.perform_now }

    assert_enqueued_with(job: RateLimitedJob) do
      RateLimitedJob.perform_now
    end
  end

  test "backing off when configured errors occur" do
    assert_enqueued_with job: ExtendedWaitJob, at: 2.minutes.from_now do
      ExtendedWaitJob.perform_now(raise_error: true)
    end
  end

  test "resuming jobs after backoff" do
    ExtendedWaitJob.perform_now(raise_error: true)

    travel 1.minute do
      perform_enqueued_jobs at: Time.now
      assert_enqueued_jobs 1
    end

    travel 3.minutes do
      assert_raises Faraday::TimeoutError do
        perform_enqueued_jobs at: Time.now
      end
    end
  end

  test "dropping jobs after max retries" do
    ExtendedWaitJob.perform_now

    assert_enqueued_with job: ExtendedWaitJob do
      ExtendedWaitJob.perform_now
    end

    travel 2.minutes do
      ExtendedWaitJob.perform_now

      assert_raises RateLimitable::Limit do
        perform_enqueued_jobs at: Time.now
      end
    end

    assert_no_enqueued_jobs
  end
end
