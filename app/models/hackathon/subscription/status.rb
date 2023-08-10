module Hackathon::Subscription::Status
  extend ActiveSupport::Concern
  extend Suppressible

  included do
    enum status: {inactive: 0, active: 1}
    after_update :track_changes, unless: -> { self.class::Status.suppressed? }

    scope :active_for, ->(user) { active.where(subscriber: user) }
  end

  # Unsubscribe URLs must be valid for at least 30 days.
  # https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business
  UNSUBSCRIBE_EXPIRATION = 2.months

  class_methods do
    def manage_subscriptions_url_for(user)
      user_signature = user.signed_id purpose: :manage_subscriptions, expires_in: UNSUBSCRIBE_EXPIRATION
      Rails.application.routes.url_helpers.user_subscriptions_url(user_signature)
    end

    def unsubscribe_all_url_for(user)
      user_signature = user.signed_id purpose: :manage_subscriptions, expires_in: UNSUBSCRIBE_EXPIRATION
      Rails.application.routes.url_helpers.unsubscribe_all_user_subscriptions_url(user_signature)
    end
  end

  def unsubscribe!
    update(status: :inactive)
  end

  def resubscribe!
    update(status: :active)
  end

  private

  def track_changes
    if changed_to_inactive?
      record(:disabled)
    end
  end

  def changed_to_inactive?
    saved_change_to_status? && inactive?
  end
end
