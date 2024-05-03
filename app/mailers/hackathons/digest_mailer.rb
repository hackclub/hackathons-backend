class Hackathons::DigestMailer < ApplicationMailer
  def digest(digest)
    @digest = digest
    @recipient = digest.recipient

    @listings_by_subscription = digest.listings
      .includes(:subscription, hackathon: {logo_attachment: :blob})
      .group_by(&:subscription)

    set_unsubscribe_urls_for @recipient
    mail to: @recipient.email_address, subject: "Hackathons near you"
  end

  def admin_summary(sent_digest_ids)
    @sent_digests = Hackathon::Digest.where(id: sent_digest_ids)

    @sent_digests_by_hackathons = @sent_digests
      .includes(listings: {hackathon: {logo_attachment: :blob}})
      .flat_map(&:listings).group_by(&:hackathon)
      .transform_values { |listings| listings.map(&:digest).uniq }

    @listed_hackathons = @sent_digests_by_hackathons.keys
      .sort_by { |hackathon| @sent_digests_by_hackathons[hackathon].count }.reverse!

    subject = <<~SUBJECT.squish
      📬 Hackathons: #{@sent_digests.count} #{"email".pluralize(@sent_digests.count)}
      sent for #{@listed_hackathons.count} #{"hackathon".pluralize(@listed_hackathons.count)}
    SUBJECT

    mail to: Hackathons::SUPPORT_EMAIL, cc: User.admins.collect(&:email_address), subject:
  end
end
