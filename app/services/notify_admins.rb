class NotifyAdmins < ApplicationService
  def initialize(hackathon_title)
    @hackathon_title = hackathon_title
  end

  def call
    User.admins.pluck(:email_address).each do |admin_email|
      UserMailer.with(name: @hackathon_title, admin_email:).hackathon_submission.deliver_now
    end
  end
end
