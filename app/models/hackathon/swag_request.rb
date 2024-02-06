class Hackathon::SwagRequest < ApplicationRecord
  include Delivered

  belongs_to :hackathon

  belongs_to :mailing_address, class_name: "MailingAddress", dependent: :destroy
  accepts_nested_attributes_for :mailing_address, update_only: true
end
