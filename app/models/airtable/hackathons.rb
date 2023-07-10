module Airtable
  class Hackathons < Airrecord::Table
    self.base_key = Rails.application.credentials.dig(:airtable, :hackathons_base)
    self.table_name = "applications"
  end
end
