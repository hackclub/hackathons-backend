class MailingAddress < ApplicationRecord
  include Eventable

  validates :line1, :city, :country_code, presence: true
  validates :country_code, inclusion: {in: ISO3166::Country.codes}

  def to_s
    components = []
    components << [line1, line2].reject(&:blank?).compact.join(" ")
    components << city << province << postal_code << country_code

    components.reject!(&:blank?)
    components.compact.join(", ")
  end
end
