require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hackathons
  class Application < Rails::Application
    config.load_defaults 7.0

    config.active_record.encryption.encrypt_fixtures = true

    # Don't use separate queues for jobs enqueued by Rails:
    config.action_mailer.deliver_later_queue_name = nil
    config.action_mailbox.queues.routing = nil
    config.action_mailbox.queues.incineration = nil
    config.active_storage.queues.analysis = nil
    config.active_storage.queues.transform = nil
    config.active_storage.queues.mirror = nil
    config.active_storage.queues.purge = nil

    host = ENV["HOST"] || "localhost:3000"
    Rails.application.routes.default_url_options[:host] = host
    config.action_mailer.default_url_options = {host:}
    config.action_mailer.default_options = {
      from: "hackathons@hackclub.com"

      # Emails sent to hackathons@hackclub.com are received by
      # the Hack Club Bank team at bank@hackclub.com
    }
  end
end
