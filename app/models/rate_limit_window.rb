class RateLimitWindow < ApplicationRecord
  scope :expired, -> { where("expiration <= ?", Time.now) }
  scope :current, -> { expired.invert_where }

  scope :on_hold, -> { where "tally < 0" }

  def on_hold?
    tally.negative?
  end

  def hold_for(duration)
    self.expiration = [expiration, duration.from_now].compact.max
    self.tally = -1

    save! unless new_record?
  end

  class << self
    def block(key, duration:)
      transaction do
        lock.find_or_initialize_by(key:).tap do
          it.hold_for duration
          it.save!
        end
      end
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    def remaining_wait_time(key)
      expiration = current.on_hold.where(key:).pick :expiration

      expiration&.- Time.now
    end

    def admit(key, limit:, duration:)
      if open_window(key, limit:, duration:)
        yield
        true
      else
        false
      end
    end

    private

    def open_window(key, limit:, duration:)
      transaction do
        expired.delete_by(key:)

        begin
          transaction(requires_new: true) do
            create! key:, tally: 1, expiration: duration.from_now
          end

          true
        rescue ActiveRecord::RecordNotUnique
          join_window(key, limit:)
        end
      end
    end

    def join_window(key, limit:)
      window = current.lock.find_by(key:)

      window&.tally&.<(limit) && !window.on_hold? && window.increment!(:tally)
    end
  end
end
