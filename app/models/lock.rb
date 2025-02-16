class Lock < ApplicationRecord
  scope :expired, -> { where "expiration <= ?", Time.now }
  scope :active, -> { expired.invert_where }

  class << self
    def acquire(key, limit: 1, duration: nil)
      lock = nil
      transaction do
        lock = active.lock.find_or_create_by!(key:)

        if lock.capacity >= limit
          return false
        else
          lock.acquire
          lock.update! expiration: duration&.from_now
        end
      end

      begin
        yield
        true
      ensure
        lock.release
      end
    end
  end

  def acquire(capacity = 1)
    increment! :capacity, capacity
  end

  def release(quantity = 1)
    with_lock do
      if capacity <= 1
        destroy!
      else
        decrement! :capacity, quantity
      end
    end
  end
end
