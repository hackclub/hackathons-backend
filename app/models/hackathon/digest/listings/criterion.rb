# Abstract base class for criteria that generate listings.
class Hackathon::Digest::Listings::Criterion
  def initialize(recipient:)
    raise NotImplementedError, "Abstract base class" if instance_of?(Hackathon::Digest::Listings::Criterion)

    @recipient = recipient
  end

  def candidate_listings
    raise NotImplementedError
  end

  private

  def upcoming_hackathons
    Hackathon.approved.upcoming
  end

  def subscriptions_to_search
    active_subscriptions = Hackathon::Subscription.active_for(@recipient).to_a
    active_subscriptions.reject do |subscription|
      # Remove subscriptions that don't have a location 📍
      return true if subscription.location.blank?

      # Remove any subscriptions that are covered by another subscription.
      # For example, "Seattle, WA, US" would be covered by a subscription to
      # "WA US" (which is more general than Seattle).
      active_subscriptions.any? do |other|
        subscription.to_location.covers?(other.to_location)
      end
    end
  end
end
