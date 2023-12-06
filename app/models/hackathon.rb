class Hackathon < ApplicationRecord
  include Broadcasting
  include Eventable
  include Taggable

  include Status

  include Applicant
  include Branded
  include FinanciallyAssisting # depends on Taggable
  include Gathering
  include Named
  include Notifying
  include Regional
  include Reviewable # depends on Eventable and Status
  include Scheduled
  include Swag
  include Website
end
