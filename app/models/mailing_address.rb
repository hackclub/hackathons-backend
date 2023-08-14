class MailingAddress < ApplicationRecord
  validates :line1, :city, :country_code, presence: true
  validates :country_code, inclusion: {in: ISO3166::Country.codes}

  def full
    components = []
    components << [line1, line2].compact.join(" ")
    components << city << province << postal_code << country_code

    components.compact.join(", ")
  end
end
