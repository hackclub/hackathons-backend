class HackathonMailer < ApplicationMailer
  before_action :set_hackathon
  layout false, only: :swag_request

  def swag_request
    @mailing_address = @hackathon.swag_request.mailing_address
    mail(to: Rails.application.credentials.swag_requests_email_address || "swag@hackathons.test")
  end

  private

  def set_hackathon
    @hackathon = params[:hackathon]
  end
end
