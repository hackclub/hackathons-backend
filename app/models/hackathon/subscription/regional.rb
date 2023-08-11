module Hackathon::Subscription::Regional
  extend ActiveSupport::Concern

  included do
    attribute :location_input
    validates :location, presence: true

    geocoded_by :location do |subscription, results|
      # Geocodes to coordinates and standardizes the location attributes
      if (result = results.first)
        subscription.attributes = {
          city: result.city,
          province: result.province || result.state,
          country_code: result.country_code.upcase,

          longitude: result.coordinates.second,
          latitude: result.coordinates.first
        }
      end
    end
    before_validation :geocode, if: -> { geocoding_needed? }
    after_save :record_result, if: -> { geocoding_needed? }

    validate :location_unique_per_subscriber, if: :active?
  end

  def location
    location_input || [city, province, country_code].compact.join(", ")
  end

  def to_location
    Location.new(city, province, country_code)
  end

  private

  def geocoding_needed?
    location_input_changed? || city_changed? || province_changed? || country_code_changed?
  end

  def location_unique_per_subscriber
    if self.class.active_for(subscriber)
        .where(city:, province:, country_code:)
        .excluding(self).exists?
      errors.add(:base, "You've already subscribed to this area!")
    end
  end

  def record_result
    if geocoded?
      record :geocoded, location_input:, location:, latitude:, longitude:
    else
      record :geocoding_failed, location_input: location
    end
  end
end
