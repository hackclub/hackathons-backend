module Hackathon::Digest::Listings::MinimizingPreviouslyListedHackathons
  private

  def candidates
    super.reject do |candidate|
      candidate.hackathon.starts_at > 1.month.from_now and
        Hackathon::Digest::Listing.exists?(hackathon: candidate.hackathon, digest: recent_digests)
    end
  end

  def recent_digests
    Hackathon::Digest.where(recipient:, created_at: 3.months.ago..)
  end
end
