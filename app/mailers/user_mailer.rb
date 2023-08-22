class UserMailer < ApplicationMailer
  self.deliver_later_queue_name = :critical

  before_action :set_user

  def authentication(authentication)
    @authentication = authentication

    mail to: @authentication.user.email_address, subject: "Sign in to Hackathons"
  end

  def hackathon_submission
    @hackathon_name = params[:name]
    @admin_email = params[:admin_email]
    mail to: @admin_email, subject: 'A new Hackathon entry was submitted!'
  end

  private

  def set_user
    @user = params&.[](:user) || Current.user
  end
end
