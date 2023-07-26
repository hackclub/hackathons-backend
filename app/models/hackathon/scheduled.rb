module Hackathon::Scheduled
  extend ActiveSupport::Concern

  included do
    validates :starts_at, presence: true
    validates :ends_at, presence: true
    validate do
      errors.add(:ends_at, :before_start_date) if errors.none? && ends_at < starts_at
    end

    scope :upcoming, -> { where("starts_at > ?", Time.now) }
  end
end
