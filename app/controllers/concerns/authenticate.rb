module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
    before_action :redirect_if_unauthenticated
  end

  private

  def authenticate
    if (session = User::Session.find_by(token: cookies.permanent.signed[:session_token]))
      session.access
      Current.session = session

      # handle cookies that weren't initially set as HTTP-only / Secure
      cookies.permanent.signed[:session_token] = {value: cookies.signed[:session_token], httponly: true, secure: Rails.env.production?}
    end
  end

  def redirect_if_unauthenticated
    redirect_to sign_in_path unless Current.user
  end

  def redirect_if_authenticated
    return redirect_to admin_hackathons_path if Current.user&.admin?
    redirect_to hackathons_submissions_path if Current.user
  end
end
