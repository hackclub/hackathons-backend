class Hackathons::WebsiteArchivalsJob < ApplicationJob
  queue_as :low

  def perform
    upcoming_or_recent_hackathons.find_each do |hackathon|
      Hackathons::WebsiteArchivalJob.perform_later(hackathon)
    end
  end

  private

  def upcoming_or_recent_hackathons
    Hackathon.approved.where("ends_at >= ?", 1.month.ago)
  end
end
