require "faraday"

class Hackathon::FindDeadWebsitesJob
  include Sidekiq::Job

  def perform
    hackathons.find_each do |hackathon|
      response = Faraday.get(hackathon.website)
      if response.status != 200 || !response.body.include? hackathon.name
        if !hackathon.tagged_with "Website down"
          hackathon.tag_with "Website down"
        end
      elsif hackathon.tagged_with "Website down"
        hackathon.untag "Website down"
      end
    end
  end

  private

  def hackathons
    # Hackathons which have already finished
    Hackathon.approved.where("ends_at < ?", Time.now)
  end
end
