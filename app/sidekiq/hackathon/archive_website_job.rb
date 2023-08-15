class Hackathon::ArchiveWebsiteJob
  include Sidekiq::Job

  def perform
    hackathons.find_each do |hackathon|
      response = Faraday.get(hackathon.website)
      if response.status != 200 && response.body.include?(hackathon.name)
        Faraday.get("https://web.archive.org/save/" + hackathon.website.sub(/^https?:\/\/(www.)?/, ""))
      end
    end
  end

  private

  def hackathons
    # Hackathons which are yet to happen or finished in the past month
    Hackathon.approved.where("ends_at >= ?", 1.month.ago)
  end
end
