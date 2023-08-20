module Hackathon::Brand::Website
  extend ActiveSupport::Concern

  included do
    validates :website, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
    validates :website, presence: true, on: :submit
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
  end
end
