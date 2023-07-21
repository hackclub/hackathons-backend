class Hackathon::Digest < ApplicationRecord
  include Eventable

  include Deliverable # utilizes Eventable

  include Listings

  belongs_to :recipient, class_name: "User"
end
