class UserMailer < ApplicationMailer
  before_action :set_user

  def authentication(authentication)
    @authentication = authentication

    mail to: @authentication.user.email_address, subject: "Sign in to Hackathons"
  end

  private

  def set_user
    @user = params & [:user] || Current.user
  end
end
