class MailingAddress < ApplicationRecord
  validates :line1, :city, :country_code, presence: true
  validates :country_code, inclusion: {in: ISO3166::Country.codes}
end
