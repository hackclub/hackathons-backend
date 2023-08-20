class Hackathons::ArchiveWebsiteJob < ApplicationJob
  def perform(hackathon)
    # This request can take a long time!

    # Web Archive will only save status 200 pages by default
    website = hackathon.website.sub(/^https?:\/\/(www.)?/, "")
    Faraday.get("https://web.archive.org/save/#{website}")

    hackathon.send(:record, :archived_website)
  end
end
