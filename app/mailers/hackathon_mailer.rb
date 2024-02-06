class HackathonMailer < ApplicationMailer
  before_action :set_hackathon

  def swag_request
    mail(to: Rails.application.credentials.swag_requests_email_address || "swag@hackathons.test")
  end

  private

  def set_hackathon
    @hackathon = params[:hackathon]
  end
end
