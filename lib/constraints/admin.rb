module Constraints
  class Admin
    def self.matches?(request)
      cookies = ActionDispatch::Cookies::CookieJar.build(request, request.cookies)
      session = User::Session.find_by(token: cookies.signed[:session_token])

      session&.user&.admin?
    end
  end
end
