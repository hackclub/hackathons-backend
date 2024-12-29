module Hackathon::Website::Archivable
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
    website.present? && website_up? && website_likely_associated?
  end

  def archive_website
    capture = InternetArchive::Capture.new(website_url: website)
    request = capture.request

    if request["status"] == "error"
      Rails.logger.warn "Internet Archive returned an error capturing #{website}:"
      Rails.logger.warn request["message"]
    else
      follow_up
    end
  end

  def follow_up_on_archive(job_id)
    if archive_with(job_id).finished?
      record :website_archived
    else
      Rails.logger.warn "Internet Archive didn't finish capture for #{website} with job #{capture.job_id}."
    end
  end

  private

  def archive_with(job_id)
    InternetArchive::Capture.new(job_id:)
  end

  class FollowUpJob < ApplicationJob
    def perform(hackathon, id)
      hackathon.follow_up_on_archive(id)
    end
  end
end
