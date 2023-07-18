module User::Authenticatable
  extend ActiveSupport::Concern

  included do
    has_many :authentications, dependent: :destroy
    has_many :sessions, through: :authentications
  end
end
