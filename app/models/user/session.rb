class User::Session < ApplicationRecord
  belongs_to :authentication
  delegate :user, to: :authentication

  has_secure_token

  def access
    touch(:last_accessed_at)
  end
end
