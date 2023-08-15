module Airtable
  class Subscriber < Airrecord::Table
    self.base_key = Rails.application.credentials.dig(:airtable, :hackathons_base)
    self.table_name = "subscribers"

    def email
      self["email"].strip
    end

    def location
      self["location"]
    end

    def coordinates
      coords = [self["latitude"], self["longitude"]]
      return nil if coords.any?(&:blank?)

      coords
    end

    def created_at
      self["created_at"]
    end

    def status
      state = (self["unsubscribed"] == 0) ? :active : :inactive
      ::Hackathon::Subscription.statuses[state]
    end

    def unsubscribed_at
      self["unsubscribed_at"]
    end
  end
end
