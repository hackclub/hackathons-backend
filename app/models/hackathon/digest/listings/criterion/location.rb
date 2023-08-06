module Hackathon::Digest::Listings
  class Criterion::Location < Criterion
    def candidate_listings
      subscriptions_to_search.flat_map do |subscription|
        # Search for hackathons **in** Subscription's location
        hackathons = hackathons_in subscription.to_location

        # Search for hackathons **near** Subscription's location
        hackathons.concat hackathons_near(subscription.to_location)

        hackathons.uniq.map { |hackathon| {hackathon:, subscription:} }
      end
    end

    private

    def hackathons_in(location)
      upcoming_hackathons.select do |hackathon|
        hackathon.to_location.covered_by_or_equal?(location)
      end
    end

    def hackathons_near(location)
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
      return [] unless location.most_significant_component == :city

      upcoming_hackathons
        .where.not(city: [nil, ""]) # where Most Significant Component is city
        .near(location.to_s, 150, units: :mi)
    end
  end
end
