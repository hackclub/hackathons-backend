module Hackathon::Digest::Listings::ByLocation
  private

  MAX_DISTANCE = 150 # miles

  def candidates
    subscriptions_to_search.flat_map { |subscription|
      hackathons_for(subscription).collect do |hackathon|
        Hackathon::Digest::Listing.new(hackathon:, subscription:)
      end
    }
  end

  def hackathons_for(subscription)
    # In order to get accurate "nearby" searches, we must have accurate
    # coordinates. Generally, coordinates obtained via geocoding are only
    # accurate when the input address is very specific. And geocoded coordinates
    # for general locations are almost useless. For example, the geocoded
    # coordinates for "United States" is located in Kansas, which is middle of
    # the country. This means that a search for "hackathons near United States"
    # is really a search for "hackathons near Kansas". So, we only search for
    # nearby hackathons if the location is specific enough (has a most
    # significant component of city).
    #
    # Highly recommended video 📺: https://www.youtube.com/watch?v=vh6zanS_epw

    hackathons = hackathons_in subscription.to_location

    if subscription.to_location.city_most_significant?
      hackathons.concat(hackathons_near(subscription.latitude, subscription.longitude)).uniq
    else
      hackathons
    end
  end

  def hackathons_in(location)
    Hackathon.all.approved.upcoming.select do |hackathon|
      hackathon.to_location.covered_by_or_equal?(location)
    end
  end

  def hackathons_near(latitude, longitude)
    Hackathon.all.approved.upcoming.where.not(city: "")
      .near([latitude, longitude], MAX_DISTANCE, units: :mi)
  end

  def subscriptions_to_search
    active_subscriptions = recipient.subscriptions.active

    active_subscriptions.reject do |subscription|
      # Remove any subscriptions that are covered by another subscription.
      # For example, "Seattle, WA, US" would be covered by a subscription to
      # "WA US" (which is more general than Seattle).
      active_subscriptions.any? do |other|
        subscription.to_location.covered_by?(other.to_location)
      end
    end
  end
end
