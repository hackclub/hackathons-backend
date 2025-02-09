class Hackathons::WebsiteArchivalJob < ApplicationJob
  rate_limit "Wayback Machine", to: 15, within: 1.minute
  queue_as :low

  def perform(hackathon)
    if hackathon.eligible_for_archive?
      hackathon.archive_website
    end
  end
end
