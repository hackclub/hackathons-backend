module Hackathon::Regional
  extend ActiveSupport::Concern

  included do
    validates :address, presence: true, on: :submit, unless: :online?

    geocoded_by :address do |hackathon, results|
      # Geocode to coordinates and standardizes the location attributes
      if (result = results.first)
        hackathon.attributes = {
          latitude: result.latitude,
          longitude: result.longitude,

          address: result.address,
          street: [result.house_number, result.street].compact.join(" ").presence,
          city: result.city,
          province: result.province || result.state,
          postal_code: result.postal_code,
          country_code: result.country_code&.upcase
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

  def country
    ISO3166::Country[country_code]&.common_name
  end

  # TODO: This method and the `apac` column is a temporary solution!
  # The column contains the migrated `apac` boolean from Airtable. Newly created
  # hackathons (after the migration) will have the `apac` column set to `nil`,
  # where it uses on the Country gem to determine if the hackathon is in APAC.
  #
  # See https://github.com/hackclub/hackathons-backend/issues/106
  def apac?
    return apac unless apac.nil?

    ISO3166::Country[country_code]&.world_region == "APAC"
  end

  def to_location
    Location.new(city, province, country_code)
  end
end
