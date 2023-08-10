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
end
