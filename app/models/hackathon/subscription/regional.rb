module Hackathon::Subscription::Regional
  extend ActiveSupport::Concern

  included do
    geocoded_by :location_input
    reverse_geocoded_by :latitude, :longitude do |object, results| # essentially formats the location
      if (result = results.first)
        object.country_code = result.country_code.upcase
        object.province = result.state_code
        object.city = result.city
      else
        record(:geocoding_failed)
      end
    end
    before_save :geocode, :reverse_geocode, if: -> { new_record? || location_changed? }
    validate :unique_location_per_subscriber, if: -> { new_record? || location_changed? }
  end

  def location
    [city, province, country_code].compact.join(", ").presence || location_input
  end

  private

  def location_changed?
    city_changed? || province_changed? || country_changed?
  end

  def unique_location_per_subscriber
    if subscriber.subscriptions.active.where.not(id:).exists?(city:, province:, country_code:)
      errors.add(:base, "You've already subscribed for this area!")
    end
  end
end
