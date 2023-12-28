class Users::SessionsController < ApplicationController
  allow_unauthenticated_access, except: :destroy
  before_action :redirect_if_authenticated, except: :destroy

  def new
    authentication = User::Authentication.find_by(token: params[:auth_token]))
    return redirect_to sign_in_path unless authentication

    if authentication.expired?
      authentication.reject reason: :expired
      return redirect_to sign_in_path
    end

    if authentication.succeeded?
      authentication.reject reason: :previously_succeeded
      return redirect_to sign_in_path
    end

    authentication.complete
    session = authentication.create_session!

    cookies.permanent.signed[:session_token] = {value: session.token, httponly: true, secure: Rails.env.production?}

    redirect_to hackathons_submissions_path
  end

  def destroy
    Current.session.destroy!
    cookies.delete :session_token
    redirect_to root_path
  end
end
