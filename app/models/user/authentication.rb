class User::Authentication < ApplicationRecord
  include Delivered

  delivered :now

  include Eventable

  belongs_to :user

  has_secure_token
  has_one :session, dependent: :destroy

  def expired?
    (created_at + VALIDITY_PERIOD).past?
  end

  def succeeded?
    events.where(action: :completed).exists?
  end

  def completed
    record :completed, by: user
  end

  def reject(reason: nil)
    record :rejected, reason:
  end

  private

  VALIDITY_PERIOD = 1.hour

  def delivery
    UserMailer.authentication(self)
  end
end
