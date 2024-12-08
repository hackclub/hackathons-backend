Rails.application.config.after_initialize do
  # AWS SES rate-limits to 14/second, so we'll set it to 10 to be safe
  ActionMailer::MailDeliveryJob.limits_concurrency key: "mail", to: 10, duration: 1.second
end
