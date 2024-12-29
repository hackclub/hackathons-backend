class Hackathons::WebsiteArchivalJob < ApplicationJob
  limits_concurrency to: 15, duration: 1.minute, group: "Wayback Machine", key: "API"
  queue_as :low

  def perform(hackathon)
    if hackathon.eligible_for_archive?
      hackathon.archive_website
    end
  end
end
