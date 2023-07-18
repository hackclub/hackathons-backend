module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
    before_action :redirect_if_unauthenticated
  end

  private

  def authenticate
    if (session = User::Session.find_by(token: cookies.encrypted[:session_token]))
      session.access
      Current.session = session
    end
  end

  def redirect_if_unauthenticated
    redirect_to sign_in_path unless Current.user
  end

  def redirect_if_authenticated
    redirect_to root_path if Current.user
  end
end
