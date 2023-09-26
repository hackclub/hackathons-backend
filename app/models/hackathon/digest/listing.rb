class Hackathon::Digest::Listing < ApplicationRecord
  belongs_to :digest, class_name: "Hackathon::Digest"
  belongs_to :hackathon
  belongs_to :subscription
  
  def previously_listed_for_recipient?(recipient: digest.recipient)
    Hackathon::Digest::Listing.where(hackathon: hackathon, recipient: recipient) > 1
  end
end
