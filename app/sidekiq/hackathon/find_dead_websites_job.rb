require "faraday"

class Hackathon::FindDeadWebsitesJob
  include Sidekiq::Job

  def perform
    past_hackathons.find_each do |hackathon|
      response = Faraday.get(hackathon.website)
      if response.status != 200 || !response.body.include? hackathon.name
        hackathon.tag_with "Website Down"
      else
        hackathon.untag "Website Down"
      end
    end
  end

  private

  def past_hackathons
    Hackathon.approved.where("ends_at < ?", Time.now)
  end
end
