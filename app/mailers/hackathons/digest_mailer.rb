class Hackathons::DigestMailer < ApplicationMailer
  def digest
    @digest = params[:digest]
    @recipient = @digest.recipient

    @listings_by_subscription = @digest.listings
      .includes(:subscription, hackathon: {logo_attachment: :blob})
      .group_by(&:subscription)

    set_unsubscribe_urls_for @recipient
    mail to: @recipient.email_address, subject: "Hackathons near you"
  end

  def admin_summary
    @digests = params[:digests]

    @digests_by_hackathons = @digests
      .includes(listings: {hackathon: {logo_attachment: :blob}})
      .flat_map(&:listings).group_by(&:hackathon)
      .transform_values { |listings| listings.map(&:digest).uniq }

    @hackathons = @digests_by_hackathons.keys
      .sort_by { |hackathon| @digests_by_hackathons[hackathon].count }.reverse!

    subject = <<~SUBJECT.squish
      📬 Hackathons: #{@digests.count} #{"email".pluralize(@digests.count)}
      sent for #{@hackathons.count} #{"hackathon".pluralize(@hackathons.count)}
    SUBJECT

    mail to: Hackathons::SUPPORT_EMAIL, cc: User.admins.map(&:email_address), subject:
  end
end
