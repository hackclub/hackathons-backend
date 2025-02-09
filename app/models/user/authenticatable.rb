module User::Authenticatable
  extend ActiveSupport::Concern

  included do
    has_many :authentications, dependent: :destroy
    has_many :sessions, through: :authentications
  end

  class_methods do
    def authenticate(token)
      if (authentication = User::Authentication.find_by(token:))
        if authentication.expired?
          authentication.reject reason: :expired
        elsif authentication.succeeded?
          authentication.reject reason: :previously_succeeded
        else
          return authentication.create_session!
        end

        nil
      end
    end
  end
end
