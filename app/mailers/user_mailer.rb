class UserMailer < ApplicationMailer
  before_action :set_user

  def authentication(authentication = nil)
    @authentication = authentication || @user.authentications.last

    mail to: @authentication.user.email_address, subject: "Sign in to Hackathons"
  end

  private

  def set_user
    @user = params & [:user] || Current.user
  end
end
