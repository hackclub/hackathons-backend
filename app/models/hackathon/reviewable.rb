module Hackathon::Reviewable
  extend ActiveSupport::Concern

  included do
    scope :reviewed_by, ->(user) {
      joins(:events)
        .where(events:
               {action: [:approved, :rejected, :held],
                creator: user})
    }
  end

  def reviewers
    events.where(action: [:approved, :rejected, :held]).collect(&:creator)
  end

  def approve
    transaction do
      record :approved
      update! status: :approved
    end
  end

  def reject
    transaction do
      record :rejected
      update! status: :rejected
    end
  end

  def hold
    transaction do
      record :held_for_review
      update! status: :pending
    end
  end
end
