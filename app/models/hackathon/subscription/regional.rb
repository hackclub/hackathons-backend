module Hackathon::Subscription::Regional
  extend ActiveSupport::Concern

  included do
    attribute :location_input
    validates :location, presence: {message: ->(object, _) { "'#{object.input_or_location}' could not be found." }}

    geocoded_by :input_or_location do |subscription, results|
      # Geocode to coordinates and standardizes the location attributes

      # Bias towards US results. This handles cases where the user enters "CA",
      # likely intending "California", but geocoding to "Canada".
      us = results.first(2).find { |r| r.country_code&.upcase == "US" }
      if (result = us || results.first)
        subscription.attributes = {
          latitude: result.latitude,
          longitude: result.longitude,

          city: result.city,
          province: result.province || result.state,
          country_code: result.country_code&.upcase
        }
      end
    end
    before_validation :geocode, if: -> { geocoding_needed? }
    after_save :record_result, if: -> { geocoding_needed? }

    validate :location_unique_per_subscriber, if: :active?
  end

  def location
    [city, province, country_code].compact.join(", ")
  end

  def input_or_location
    location_input || location
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
      errors.add(:base, message: "You've already subscribed to this area!")
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
