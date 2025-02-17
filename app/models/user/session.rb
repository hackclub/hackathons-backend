class User::Session < ApplicationRecord
  belongs_to :authentication
  delegate :user, to: :authentication

  has_secure_token

  after_create -> { authentication.completed }

  def access
    touch :last_accessed_at unless ENV["READ_ONLY_MODE"]
    self
  end
end
