class RateLimitWindow < ApplicationRecord
  scope :expired, -> { where("expiration <= ?", Time.now) }
  scope :active, -> { expired.invert_where }

  class << self
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
      window = active.lock.find_by(key:)
      window&.tally&.<(limit) && window.increment!(:tally)
    end
  end
end
