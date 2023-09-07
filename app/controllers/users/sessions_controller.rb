class Users::SessionsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated, except: :destroy
  before_action :redirect_if_authenticated, except: :destroy

  def new
    authentication = User::Authentication.find_by(token: params[:auth_token])
    return redirect_to sign_in_path if authentication.nil?

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

    cookies.permanent.signed[:session_token] = {value: session.token, httponly: true}
    redirect_to root_path
  end

  def destroy
    Current.session.destroy!
    cookies.permanent.signed[:session_token] = nil
    redirect_to sign_in_path
  end
end
