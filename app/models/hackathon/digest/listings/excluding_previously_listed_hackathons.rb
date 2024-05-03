module Hackathon::Digest::Listings::ExcludingPreviouslyListedHackathons
  private

  def candidates
    super.reject do |candidate|
      if candidate.hackathon.starts_at < 1.month.from_now then false
      else
        Hackathon::Digest::Listing.exists?(hackathon: candidate.hackathon, digest: previous_digests)
      end
    end
  end

  def previous_digests
    Hackathon::Digest.where(recipient:, created_at: 3.months.ago..)
  end
end
