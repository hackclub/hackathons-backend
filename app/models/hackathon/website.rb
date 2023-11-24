module Hackathon::Website
  extend ActiveSupport::Concern

  include Archivable

  included do
    validates :website, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
    validates :website, presence: true, on: :submit
  end

  def website_up?
    !website_down?
  end

  def website_down?
    tagged_with? "Website Down"
  end

  def refresh_website_status
    website_response&.success? ? untag("Website Down") : tag_with!("Website Down")
  end

  def website_likely_unassociated?
    !website_likely_associated?
  end

  def website_likely_associated?
    website_response&.body&.downcase&.include?(name.downcase)
  end

  private

  def website_response
    @website_response ||= begin
      connection = Faraday.new do |f|
        f.response :follow_redirects
      end
      connection.get website
    rescue Faraday::Error
      nil
    end
  end
end
