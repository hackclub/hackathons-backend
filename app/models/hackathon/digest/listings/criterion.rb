# Abstract base class for criteria that generate listings.
class Hackathon::Digest::Listings::Criterion
  def initialize(recipient:)
    raise NotImplementedError, "Abstract base class" if instance_of?(Hackathon::Digest::Listings::Criterion)

    @recipient = recipient
  end

  def candidate_listings
    raise NotImplementedError
  end

  private

  def upcoming_hackathons
    Hackathon.approved.upcoming
  end
end
