module Hackathon::Swag
  extend ActiveSupport::Concern

  # Hack Club will ship stickers, postcards, and other swag to the mailing
  # address provided! yay!

  included do
    belongs_to :swag_mailing_address, class_name: "MailingAddress", optional: true
    accepts_nested_attributes_for :swag_mailing_address
  end

  def requested_swag?
    swag_mailing_address.present?
  end
end
