module RateLimitable
  extend ActiveSupport::Concern

  DEFAULT_MAX_RETRIES = 10

  class Limit < StandardError
    attr_reader :key, :duration

    def initialize(key:, duration:)
      @key = key
      @duration = duration
      super()
    end
  end

  class_methods do
    def rate_limit(key = name, to:, within:, extend_wait: nil, max_retries: DEFAULT_MAX_RETRIES)
      key = key.to_s
      limit = to.to_i
      duration = [within.to_f, 1].max.seconds

      self.max_rate_limit_retries = [max_retries.to_i, 0].max
      configure_extended_wait(key:, extend_wait:, max_attempts: max_rate_limit_retries) if extend_wait

      around_perform do |job, block|
        enforce_extended_wait(key) if extend_wait

        unless RateLimitWindow.admit(key, limit:, duration:) { block.call }
          raise Limit.new(key:, duration:)
        end
      end
    end

    private

    def configure_extended_wait(key:, extend_wait:, max_attempts:)
      wait = [extend_wait.fetch(:for).to_f, 1].max.seconds

      Array(extend_wait.fetch(:on)).each do |error_type|
        rescue_from error_type do |error|
          raise error unless retryable_rate_limit_attempt?(max_attempts)

          Rails.error.report error, handled: true
          RateLimitWindow.block(key, duration: wait)
          retry_job wait:
        end
      end
    end
  end

  included do
    class_attribute :max_rate_limit_retries, default: DEFAULT_MAX_RETRIES

    rescue_from Limit do
      raise it unless retryable_rate_limit_attempt?(self.class.max_rate_limit_retries)

      Rails.error.report it, handled: true
      retry_job wait: [it.duration.to_f, 1].max.seconds
    end
  end

  private

  def retryable_rate_limit_attempt?(max_retries)
    executions < (max_retries + 1)
  end

  def enforce_extended_wait(key)
    wait = RateLimitWindow.remaining_wait_time(key)

    raise Limit.new(key:, duration: wait) if wait&.positive?
  end
end
