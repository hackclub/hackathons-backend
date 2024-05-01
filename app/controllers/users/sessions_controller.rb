class Users::SessionsController < ApplicationController
  allow_unauthenticated_access except: :destroy
  before_action :redirect_if_authenticated, except: :destroy

  def new
    if (auth = User.authenticate(params[:auth_token]))
      cookies.permanent.signed[:session_token] = {value: auth.token, httponly: true, secure: Rails.env.production?}
      redirect_to hackathons_submissions_path
    else
      redirect_to sign_in_path, notice: "Invalid or expired, try again!"
    end
  end

  def destroy
    Current.session.destroy!
    cookies.delete :session_token
    redirect_to root_path
  end
end
