class Users::SessionsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated, except: :destroy
  before_action :redirect_if_authenticated, except: :destroy

  def new
    if (authentication = User::Authentication.find_by(token: params[:auth_token]))
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

      cookies.encrypted[:session_token] = session.token
      redirect_to root_path
    else
      redirect_to sign_in_path
    end
  end

  def destroy
    Current.session.destroy!
    cookies.encrypted[:session_token] = nil
    redirect_to root_path
  end
end
