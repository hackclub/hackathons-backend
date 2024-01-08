class DatabaseDump < ApplicationRecord
  TABLES = %w[hackathons]

  include Broadcasting
  include Eventable

  include Processed

  def name
    time = created_at || Time.now
    super.presence || time.strftime("%B %-d, %Y")
  end
end
