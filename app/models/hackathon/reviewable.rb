module Hackathon::Reviewable
  extend ActiveSupport::Concern

  included do
    scope :reviewed_by, ->(user) do
      joins(:events).where(events: {action: REVIEW_ACTIONS, creator: user})
    end

    after_save :record_status, if: :saved_change_to_status?
  end

  def reviewers
    events.includes(:creator).where(action: REVIEW_ACTIONS).collect(&:creator)
  end

  def hold
    transaction do
      update! status: :pending
      record :held_for_review
    end
  end

  private

  REVIEW_ACTIONS = %i[approved rejected held_for_review]

  def record_status
    record status unless pending?
  end
end
