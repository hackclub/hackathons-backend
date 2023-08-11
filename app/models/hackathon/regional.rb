module Hackathon::Regional
  extend ActiveSupport::Concern

  included do
    validates :address, presence: true, on: :submit

    geocoded_by :address do |hackathon, results|
      # Geocodes to coordinates and standardizes the location attributes
      if (result = results.first)
        hackathon.attributes = {
          latitude: result.coordinates.first,
          longitude: result.coordinates.second,

          address: result.address,
          street: [result.house_number, result.street].compact.join(" ").presence,
          city: result.city,
          province: result.province || result.state,
          postal_code: result.postal_code,
          country_code: result.country_code.upcase
        }
      end
    end
    before_save :geocode, if: -> { (new_record? || address_changed?) && valid? }
  end

  def address
    super.presence || [street, city, province, postal_code, country_code].compact.join(", ")
  end

  def general_location
    [city, province, country_code].compact.join(", ")
  end

  def to_location
    Location.new(city, province, country_code)
  end
end
