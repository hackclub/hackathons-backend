class Hackathon::Digest < ApplicationRecord
  include Eventable

  include Deliverable # utilizes Eventable

  include Listings

  belongs_to :recipient, class_name: "User"

  private

  def delivery
    Hackathon::DigestMailer.with(digest: self).digest
  end
end
