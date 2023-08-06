module Hackathon::Scheduled
  extend ActiveSupport::Concern

  included do
    scope :upcoming, -> { where("starts_at > ?", Time.now) }

    validates :starts_at, presence: true
    validates :ends_at, presence: true

    validate :dates_are_chronological,
      unless: -> { errors.include?(:starts_at) || errors.include?(:ends_at) }

    validate :dates_are_in_the_future, on: :submit,
      unless: -> { errors.include?(:starts_at) || errors.include?(:ends_at) }
  end

  private

  def dates_are_chronological
    if ends_at < starts_at
      errors.add(:ends_at, :before_the_start)
    end
  end

  def dates_are_in_the_future
    if starts_at < Time.now
      errors.add(:starts_at, :in_the_past)
    end

    if ends_at < Time.now
      errors.add(:ends_at, :in_the_past)
    end
  end
end
