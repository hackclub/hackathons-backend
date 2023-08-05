class Hackathon::DigestMailer < ApplicationMailer
  def by_location
    @digest = params[:digest]
    @recipient = @digest.recipient

    @listings_by_subscription = @digest.listings.group_by(&:subscription)

    mail to: @recipient.email_address, subject: "Hackathons near you"
  end
end
