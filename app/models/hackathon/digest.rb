class Hackathon::Digest
  def initialize(user:, max_hackathons: nil)
    @user = user
  end

  def relevant_hackathons
    nearby_upcoming_hackathons
  end

  private

  attr_reader :user

  def nearby_upcoming_hackathons
    locations_to_search.map do |location|
      upcoming_hackathons.near(location, 50, units: :mi)
    end
  end

  def locations_to_search
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

  def active_subscriptions
    Subscription.active_for(user)
  end

  def upcoming_hackathons
    Hackathon.approved.where("starts_at > ?", Time.now)
  end
end
