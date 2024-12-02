require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hackathons
  class Application < Rails::Application
    config.load_defaults 7.2

    config.autoload_lib ignore: %w[assets tasks templates puma]

    config.active_record.encryption.hash_digest_class = OpenSSL::Digest::SHA1
    config.active_record.encryption.encrypt_fixtures = true

    config.active_record.automatically_invert_plural_associations = true

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
