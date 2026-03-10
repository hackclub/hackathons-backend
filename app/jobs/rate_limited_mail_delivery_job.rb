class RateLimitedMailDeliveryJob < ActionMailer::MailDeliveryJob
  include RateLimitable

  rate_limit to: 10, within: 1.second
end
