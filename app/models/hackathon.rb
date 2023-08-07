class Hackathon < ApplicationRecord
  include Eventable
  include Taggable

  include Applicant
  include Brand
  include FinanciallyAssisting # depends on Taggable
  include Gathering
  include Named
  include Regional
  include Scheduled
  include Status
  include Swag
end
