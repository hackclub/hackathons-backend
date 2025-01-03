Rails.application.config.after_initialize do
  # AWS SES rate-limits to 14/second, so we'll set it to 10 to be safe
  ActionMailer::MailDeliveryJob.include(RateLimitable)
    .rate_limit to: 10, within: 1.second
end
