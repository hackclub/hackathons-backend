module RateLimitable
  extend ActiveSupport::Concern

  class Limit < StandardError
    attr_reader :duration
    def initialize(duration: nil)
      @duration = duration
      super
    end
  end

  class_methods do
    def rate_limit(key = name, to:, within:)
      around_perform do |job, block|
        unless Lock.acquire(key, limit: to, duration: within) { block }
          raise Limit.new(duration:)
        end
      end
    end
  end

  included do
    rescue_from RateLimitable::Limit do |limit|
      retry_job wait: limit.duration
      logger.info "#{self.class.name} #{job_id} was rate limited for at least #{limit.duration.inspect}"
    end
  end
end
