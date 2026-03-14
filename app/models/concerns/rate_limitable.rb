module RateLimitable
  extend ActiveSupport::Concern

  class Limit < StandardError
    attr_reader :key, :duration

    def initialize(key:, duration:)
      @key = key
      @duration = duration
      super()
    end
  end

  class_methods do
    def rate_limit(key = name, to:, within:, extend_wait: nil)
      configure_extended_wait(key:, extend_wait:) if extend_wait

      around_perform do |job, block|
        enforce_extended_wait(key) if extend_wait

        unless RateLimitWindow.admit(key, limit: to, duration: within) { block.call }
          raise Limit.new(key:, duration: within)
        end
      end
    end

    private

    def configure_extended_wait(key:, extend_wait:)
      wait = [extend_wait.fetch(:for).to_f, 1].max.seconds

      Array(extend_wait.fetch(:on)).each do |error_type|
        rescue_from error_type do |error|
          Rails.error.report error, handled: true

          RateLimitWindow.block(key, duration: wait)
          retry_job wait: wait
        end
      end
    end
  end

  included do
    rescue_from Limit do
      retry_job wait: [it.duration.to_f, 1].max.seconds
    end
  end

  private

  def enforce_extended_wait(key)
    wait = RateLimitWindow.remaining_wait_time(key)

    raise Limit.new(key:, duration: wait) if wait&.positive?
  end
end
