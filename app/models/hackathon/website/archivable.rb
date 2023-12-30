module Hackathon::Website::Archivable
  extend ActiveSupport::Concern

  included do
    after_create_commit :archive_website_later
  end

  def website_or_archive_url
    if website_down? && website_archived?
      "https://web.archive.org/#{website.sub(/^https?:\/\/(www.)?/, "")}"
    else
      website
    end
  end

  def website_archived?
    if events.loaded?
      events.any? { |e| e.action == "archived_website" }
    else
      events.where(action: "archived_website").exists?
    end
  end

  def eligible_for_archive?
    website_up? && website_likely_associated?
  end

  def archive_website
    capture = InternetArchive::Capture.new(website)
    request = capture.request

    if request["status"] == "error"
      Rails.logger.info "Internet Archive returned an error capturing #{website}:"
      Rails.logger.info request["message"]
      return
    end

    begin
      Timeout.timeout(3.minutes) do
        sleep 5 until capture.finished?
      end

      record :archived_website if capture.finished?
    rescue Timeout::Error
      Rails.logger.info "Timed out waiting for Internet Archive to finish capture for #{website} with job #{capture.job_id}."
    end
  end

  private

  def archive_website_later
    Hackathons::WebsiteArchivalJob.perform_later(self)
  end
end
