class Hackathons::RefreshWebsiteStatusesJob < ApplicationJob
  queue_as :low

  def perform
    past_hackathons.find_each do |hackathon|
      hackathon.refresh_website_status
    end
  end

  private

  def past_hackathons
    Hackathon.approved.where("ends_at < ?", Time.now)
  end
end
