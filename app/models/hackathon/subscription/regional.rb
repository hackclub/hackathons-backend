module Hackathon::Subscription::Regional
  extend ActiveSupport::Concern

  included do
    attribute :location_input
    validates :location_input, presence: true, unless: -> { city? || province? || country_code? }

    geocoded_by :location
    reverse_geocoded_by :latitude, :longitude do |object, results| # essentially formats the location
      if (result = results.first)
        object.country_code = result.country_code.upcase
        object.province = result.province || result.state
        object.city = result.city
      end
    end
    before_validation :geocode, :reverse_geocode, if: -> { geocoding_needed? }
    after_save :record_result, if: -> { geocoding_needed? }

    validate :location_unique_per_subscriber, if: -> { geocoding_needed? }
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
