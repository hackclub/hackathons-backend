module Airtable
  class Hackathon < Airrecord::Table
    self.base_key = Rails.application.credentials.dig(:airtable, :hackathons_base)
    self.table_name = "applications"

    def name
      self["name"].strip
    end

    def applicant_email
      email = self["applicant_email"]&.strip || "hackathons+airtable_migration@hackclub.com"
      return email if email.match? URI::MailTo::EMAIL_REGEXP

      # Some records have multiple emails separated by commas
      email.split(",").first&.strip
    end

    def starts_at
      self["start"]
    end

    def ends_at
      self["end"]
    end

    def website
      url = URI.parse(self["website"].strip)
      url = URI.parse("http://#{url}") unless url.scheme
      url.to_s
    end

    def expected_attendees
      attendees = self["expected_attendance"] || 1
      (attendees > 0) ? attendees : 1
    end

    def apac
      !!self["apac"]
    end

    def created_at
      self["created_at"]
    end

    def modality
      return ::Hackathon.modalities[:online] if self["virtual"]
      return ::Hackathon.modalities[:hybrid] if self["hybrid"]
      ::Hackathon.modalities[:in_person]
    end

    def status
      return ::Hackathon.statuses[:approved] if self["approved"]
      return ::Hackathon.statuses[:rejected] if self["rejected"]
      ::Hackathon.statuses[:pending]
    end

    def high_school_led
      !!self["Are you a high schooler?"]
    end

    def offers_financial_assistance
      !!self["Would you like to apply for financial assistance?"]
    end

    def full_address
      city = self["parsed_city"]
      state = self["parsed_state_code"]
      country = self["parsed_country"]
      country_code = self["parsed_country_code"]

      [city, state, country || country_code].compact.join(", ")
    end

    def swag_mailing_address
      return nil unless offers_financial_assistance

      line1 = self["Address Line 1"]
      line2 = self["Address Line 2"]
      city = self["Mailing address (City)"]
      province = self["Mailing Address (State)"]
      postal_code = self["Mailing Address (Zip code)"]
      country_code = ISO3166::Country.find_country_by_any_name(self["Mailing Address (Country)"])&.alpha2

      invalid = [line1, city, country_code].any?(&:blank?)
      if invalid
        address = []
        address << [line1, line2].compact.join(" ")
        address << city << province << postal_code << country_code
        address = address.compact.join(", ")

        location = Geocoder.search(address).first
        return nil unless location

        line1 = [location.house_number, location.street].compact.join(" ")
        line2 = nil
        city = location.city
        province = location.province || location.state
        postal_code = location.postal_code
        country_code = location.country_code.upcase
      end

      {line1:, line2:, city:, province:, postal_code:, country_code:}
    end

    def coordinates
      coords = [self["lat"], self["lng"]]
      return nil if coords.any?(&:blank?)

      coords
    end

    def logo
      url = self["logo"]&.last&.[]("url")
      return nil unless url.present?
      URI.parse(url).open
    end

    def logo_filename
      self["logo"]&.last&.[]("filename")
    end

    def banner
      url = self["banner"]&.last&.[]("url")
      return nil unless url.present?

      URI.parse(url).open
    end

    def banner_filename
      self["banner"]&.last&.[]("filename")
    end
  end
end
