class Hackathon::Digest < ApplicationRecord
  include Deliverable

  include Listings

  belongs_to :recipient, class_name: "User"

  private

  def delivery
    Hackathons::DigestMailer.with(digest: self).digest
  end
end
