class Hackathon::Digest < ApplicationRecord
  include Delivered
  include Listings

  belongs_to :recipient, class_name: "User"

  private

  def delivery
    Hackathons::DigestMailer.digest(self)
  end
end
