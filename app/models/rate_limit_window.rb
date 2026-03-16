class RateLimitWindow < ApplicationRecord
  validates_presence_of :key, :tally, :expiration

  scope :expired, -> { where("expiration <= ?", Time.now) }
  scope :current, -> { where("expiration > ?", Time.now) }

  scope :on_hold, -> { where "tally < 0" }
  scope :not_on_hold, -> { where "tally >= 0" }

  def on_hold?
    tally.negative?
  end

  class << self
    def block(key, duration:)
      upsert(
        {key:, tally: -1, expiration: duration.from_now}, unique_by: :key, on_duplicate:
          Arel.sql("expiration = GREATEST(rate_limit_windows.expiration, EXCLUDED.expiration), tally = -1")
      )
    end

    def remaining_wait_time(key)
      expiration = current.on_hold.where(key:).pick :expiration

      expiration&.- Time.now
    end

    def admit(key, limit:, duration:)
      if join_window(key, limit:) || open_window(key, limit:, duration:)
        yield
        true
      else
        false
      end
    end

    private

    def open_window(key, limit:, duration:)
      expired.delete_by(key:)

      begin
        create! key:, tally: 1, expiration: duration.from_now
        true
      rescue ActiveRecord::RecordNotUnique
        join_window(key, limit:)
      end
    end

    def join_window(key, limit:)
      current.not_on_hold.where("key = ? AND tally < ?", key, limit)
        .update_all("tally = tally + 1").positive?
    end
  end
end
