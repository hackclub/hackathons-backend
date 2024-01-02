class Hackathons::SubmissionMailer < ApplicationMailer
  before_action :set_hackathon

  def confirmation
    mail to: @hackathon.applicant.email_address, subject: "Your hackathon was submitted!"
  end

  def admin_notification
    email_addresses = User.admins.with_setting_enabled(:new_hackathon_submission_notifications).pluck :email_address
    mail to: email_addresses, subject: "A new hackathon named \"#{@hackathon.name}\" was submitted!"
  end

  def approval
    mail to: @hackathon.applicant.email_address, subject: "Your hackathon submission was approved!"
  end

  private

  def set_hackathon
    @hackathon = params[:hackathon]
  end
end
