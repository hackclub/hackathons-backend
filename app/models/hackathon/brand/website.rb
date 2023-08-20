module Hackathon::Brand::Website
  extend ActiveSupport::Concern

  included do
    validates :website, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
    validates :website, presence: true, on: :submit

    after_create_commit :archive_website_later
  end

  def archived_website_url
    "https://web.archive.org/#{website.sub(/^https?:\/\/(www.)?/, "")}"
  end

  def website_down?
    !website_up?
  end

  def website_up?
    response = Faraday.get website
    response.status == 200 && response.body.include?(name)
  rescue StandardError
    false
  end

  def website_archived?
    events.any? { |event| event.action == "archived_website" }
  end

  private

  def archive_website_later
    Hackathons::ArchiveWebsiteJob.perform_later(self)
  end
end
