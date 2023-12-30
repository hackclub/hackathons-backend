class Hackathons::WebsiteArchivalJob < ApplicationJob
  queue_as :low

  def perform(hackathon)
    if hackathon.eligible_for_archive?
      hackathon.archive_website
    end
  end
end
