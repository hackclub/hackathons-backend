class Hackathons::SendOrganizerSummariesJob < ApplicationJob
  def perform(sent_digests)
    # This reloads the (possible) sent_digests array as an
    # ActiveRecord::Relation so that we can use includes to prevent an N+1.
    @sent_digests = Hackathon::Digest.where(id: sent_digests.map(&:id))

    @sent_digests_by_hackathons = @sent_digests
      .includes(listings: {hackathon: {logo_attachment: :blob}})
      .flat_map(&:listings).group_by(&:hackathon)
      .transform_values { |listings| listings.map(&:digest).uniq }

    @listed_hackathons = @sent_digests_by_hackathons.keys
    @listed_hackathons.each do |hackathon|
      sent_digests = @digests_by_hackathons[hackathon]
      Hackathons::DigestMailer.organizer_summary(sent_digests, hackathon).deliver_later if @sent_digests.any?
    end
  end
end
