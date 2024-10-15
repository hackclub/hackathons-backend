Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV["REDIS_URL"],
    ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}
  }

  config.capsule("AWS SES") do |capsule| # avoid rate limits
    Rails.configuration.action_mailer.deliver_later_queue_name = "SES"
    capsule.queues = ["SES"]
    capsule.concurrency = 1
  end
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV["REDIS_URL"],
    ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}
  }
end
