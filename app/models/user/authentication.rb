class User::Authentication < ApplicationRecord
  include Deliverable
  include Eventable

  belongs_to :user

  has_secure_token
  has_one :session, dependent: :destroy

  def expired?
    (created_at + AUTHENTICATION_VALIDITY_PERIOD).past?
  end

  def succeeded?
    events.where(action: :completed).exists?
  end

  def complete
    record :completed, by: user
  end

  private

  def delivery
    UserMailer.authentication(self)
  end

  AUTHENTICATION_VALIDITY_PERIOD = 1.hour
end
