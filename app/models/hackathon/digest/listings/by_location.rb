module Hackathon::Digest::Listings::ByLocation
  extend ActiveSupport::Concern
  extend Suppressible

  private

  def nearby_upcoming_hackathons
    subscriptions_to_search.flat_map do |subscription|
      # Searching for hackathons **in** Subscription's location
      hackathons = upcoming_hackathons.select do |hackathon|
        hackathon.to_location.covered_by_or_equal?(subscription.to_location)
      end

      # Searching for hackathons **near** Subscription's location
      if subscription.to_location.most_significant_component == :city
        nearby_hackathons = upcoming_hackathons
          .near(subscription.location, 150, units: :mi)
          .where.not(city: [nil, ""])

        hackathons.concat(nearby_hackathons).uniq!
      end

      hackathons.map { |hackathon| {hackathon:, subscription:} }
    end
  end

  def subscriptions_to_search
    # If this needs to be more performant, it can be implemented as a tree. Each
    # node represents a single components. The root node is the "world".
    # Children of the "world" are countries. Children of countries are
    # provinces, and children of provinces are cities. Subscriptions should be
    # attached to the significant component's node.
    #
    # To determine the list of subscriptions, walk the tree starting at the root
    # node. When you reach a node with a subscription, add it to the list. Then
    # skip it's children and continue walking the tree starting at the next
    # sibling node.

    active_subscriptions = Hackathon::Subscription.active_for(recipient).to_a
    active_subscriptions.reject do |subscription|
      return true if subscription.location.blank?

      active_subscriptions.any? do |other|
        subscription.to_location.covers?(other.to_location)
      end
    end
  end

  def upcoming_hackathons
    Hackathon.approved.upcoming
  end
end
