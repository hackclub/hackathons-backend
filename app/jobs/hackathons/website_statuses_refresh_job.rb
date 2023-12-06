class Hackathons::WebsiteStatusesRefreshJob < ApplicationJob
  queue_as :low

  def perform
    past_hackathons.find_each do |hackathon|
      ::Hackathons::WebsiteStatusRefreshJob.perform_later(hackathon)
    end
  end

  private

  def past_hackathons
    Hackathon.approved.where("ends_at < ?", Time.now)
  end
end
