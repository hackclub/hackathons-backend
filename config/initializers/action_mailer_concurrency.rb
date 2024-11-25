config.after_initialize do
  # AWS SES rate-limits to 14/second, so we'll set it to 10 to be safe
  ActionMailer::MailDeliveryJob.limits_concurrency key: "mail", to: 10 * 1.minute.to_i, duration: 1.minute
end
