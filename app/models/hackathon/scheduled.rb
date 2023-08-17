module Hackathon::Scheduled
  extend ActiveSupport::Concern

  included do
    scope :upcoming, -> { where("starts_at > ?", Time.now) }

    validates :starts_at, presence: true
    validates :ends_at, presence: true

    validate :dates_are_chronological
    validate :dates_are_in_the_future, on: :submit
  end

  def start_date
    starts_at.to_date
  end

  def end_date
    ends_at.to_date
  end

  private

  def dates_are_chronological
    if ends_at < starts_at
      errors.add(:ends_at, :non_chronological, message: "must be after the start time")
    end
  end

  def dates_are_in_the_future
    if starts_at < Time.now
      errors.add(:starts_at, :in_the_past, message: "must be in the future")
    end

    if ends_at < Time.now
      errors.add(:ends_at, :in_the_past, message: "must be in the future")
    end
  end
end
