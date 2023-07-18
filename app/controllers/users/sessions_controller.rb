class Users::SessionsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated, except: :destroy
  before_action :redirect_if_authenticated, except: :destroy

  def new
    if (authentication = User::Authentication.find_by(token: params[:auth_token]))
      return redirect_to sign_in_path if authentication.expired? || authentication.succeeded?

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
