module Hackathon::Digest::Listings::ByLocation
  extend ActiveSupport::Concern
  extend Suppressible

  private

  def nearby_upcoming_hackathons
    locations_to_search.flat_map do |location|
      upcoming_hackathons.near(location, 50, units: :mi)
    end.compact.uniq
  end

  def locations_to_search
    active_subscriptions = Hackathon::Subscription.active_for(recipient)
    locations = active_subscriptions.collect(&:location).compact.uniq

    locations.sort_by! do |location| # sort by least specific to most specific location
      location.split(", ").length
    end

    locations.reject! do |location| # don't include those superseded by more general locations
      locations.any? do |previous_location|
        previous_location.start_with?(location)
      end
    end

    locations.compact.uniq
  end

  def upcoming_hackathons
    Hackathon.approved.where("starts_at > ?", Time.now)
  end
end
