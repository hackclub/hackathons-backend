require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hackathons
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_record.encryption.encrypt_fixtures = true

    host = ENV["HOST"] || Rails.application.credentials.dig(:default_url_host, Rails.env) || "localhost:3000"
    Rails.application.routes.default_url_options[:host] = host

    config.action_mailer.default_url_options = {host:}
    config.action_mailer.default_options = {
      from: "hackathons@hackclub.com"

      # Emails sent to hackathons@hackclub.com are received by
      # the Hack Club Bank team at bank@hackclub.com
    }
  end
end
