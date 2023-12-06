class Hackathons::WebsiteStatusesRefreshJob < ApplicationJob
  queue_as :low

  def perform(hackathon)
    hackathon.refresh_website_status
  end
end
