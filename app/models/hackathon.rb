class Hackathon < ApplicationRecord
  include Eventable
  include Taggable
  include Deliverable

  include Status

  include Applicant
  include Brand
  include Brand::Website
  include FinanciallyAssisting # depends on Taggable
  include Gathering
  include Named
  include Regional
  include Reviewable # depends on Eventable and Status
  include Scheduled
  include Swag

  def delivery
    HackathonMailer.with(name:, email: User.admins).submission
  end
end
