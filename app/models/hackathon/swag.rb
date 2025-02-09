module Hackathon::Swag
  extend ActiveSupport::Concern

  # Hack Club will ship stickers, postcards, and other swag to the mailing
  # address provided! yay!

  included do
    belongs_to :swag_mailing_address, class_name: "MailingAddress", optional: true

    has_one :swag_request, dependent: :destroy
    accepts_nested_attributes_for :swag_request

    after_commit :deliver_swag_request_later_if_pertinent
  end

  def requested_swag?
    swag_request
  end

  private

  SWAG_REQUEST_GRACE_PERIOD = 1.minute

  def deliver_swag_request_later_if_pertinent
    swag_request&.deliver_later_if_pertinent(wait: SWAG_REQUEST_GRACE_PERIOD)
  end
end
