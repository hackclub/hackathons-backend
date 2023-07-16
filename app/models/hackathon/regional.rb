module Hackathon::Regional
  extend ActiveSupport::Concern

  included do
    geocoded_by :address
    reverse_geocoded_by :latitude, :longitude do |hackathon, results| # essentially formats the location
      if (result = results.first)
        hackathon.country_code = result.country_code
        hackathon.province = result.province || result.state
        hackathon.city = result.city
        hackathon.postal_code = result.postal_code
        hackathon.address = result.address
      end
    end

    before_save :geocode, :reverse_geocode, if: -> { (new_record? || address_changed?) && valid? }
  end

  def state
    province
  end
end
