class User::Authentication < ApplicationRecord
  include Deliverable
  delivered :now
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

  def reject(reason: nil)
    record :rejected, reason: reason
  end

  private

  def delivery
    UserMailer.authentication(self)
  end

  AUTHENTICATION_VALIDITY_PERIOD = 1.hour
end
