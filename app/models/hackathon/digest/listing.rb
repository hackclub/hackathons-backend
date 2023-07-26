class Hackathon::Digest::Listing < ApplicationRecord
  belongs_to :digest, class_name: "Hackathon::Digest"
  belongs_to :hackathon
  belongs_to :subscription
end
