class UserMailer < ApplicationMailer
  def authentication
    @authentication = params[:authentication]
    @user = @authentication.user

    mail to: @user.email_address, subject: "Sign in to Hackathons"
  end
end
