module Hackathon::Subscription::Status
  extend ActiveSupport::Concern
  extend Suppressible

  included do
    enum status: {inactive: 0, active: 1}
    after_update :track_changes, unless: -> { self.class::Status.suppressed? }

    scope :active_for, ->(user) { active.where(subscriber: user) }
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
