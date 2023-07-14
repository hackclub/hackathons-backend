module Airtable
  class Subscriber < Airrecord::Table
    self.base_key = Rails.application.credentials.dig(:airtable, :hackathons_base)
    self.table_name = "subscribers"
  end
end
