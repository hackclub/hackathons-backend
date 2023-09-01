class HackathonMailer < ApplicationMailer
  before_action :set_hackathon

  def submission
    email_addresses = User.admins.pluck(&:email_address)
    mail to: email_addresses, subject: "A new Hackathon named \"#{@hackathon.name}\" was submitted!"
  end

  private

  def set_hackathon
    @hackathon = params[:hackathon]
  end
end
