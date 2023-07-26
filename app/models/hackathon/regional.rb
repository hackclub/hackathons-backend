module Hackathon::Regional
  extend ActiveSupport::Concern

  included do
    geocoded_by :address
    reverse_geocoded_by :latitude, :longitude do |hackathon, results| # essentially formats the location
      if (result = results.first)
        hackathon.country_code = result.country_code.upcase
        hackathon.postal_code = result.postal_code
        hackathon.province = result.province || result.state
        hackathon.city = result.city
        hackathon.address = result.address
        hackathon.street = [result.try(:house_number), result.try(:street)].compact.join(" ").presence
      end
    end

    before_save :geocode, :reverse_geocode, if: -> { (new_record? || address_changed?) && valid? }
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
