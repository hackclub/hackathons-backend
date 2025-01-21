class Lock < ApplicationRecord
  scope :expired, -> { where "expiration <= ?", Time.now }
  scope :active, -> { expired.invert_where }

  class << self
    def acquire(key, limit: 1, duration: nil)
      lock = nil
      transaction do
        lock = active.find_by(key:) || create!(key:, expiration: duration&.from_now)

        if lock.capacity >= limit
          return false
        else
          lock.acquire
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
    transaction do
      reload
      if capacity <= 1
        destroy!
      else
        decrement! :capacity, quantity
      end
    end
  end
end
