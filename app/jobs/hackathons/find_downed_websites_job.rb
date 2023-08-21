class Hackathons::FindDownedWebsitesJob < ApplicationJob
  queue_as :low

  def perform
    past_hackathons.find_each do |hackathon|
      if hackathon.website_down?
        hackathon.tag_with!("Website Down")
      else
        hackathon.untag("Website Down")
      end
    end
  end

  private

  def past_hackathons
    Hackathon.approved.where("ends_at < ?", Time.now)
  end
end
