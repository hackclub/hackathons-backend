class Lock < ApplicationRecord
  scope :expired, -> { where "expiration <= ?", Time.now }

  class << self
    def acquire(key, limit: 1, duration: nil, &block)
      lock = nil
      transaction do
        lock = find_by(key:) || create!(key:, expiration: duration&.from_now)
        if lock.capacity == limit
          return false
        end
      end

      lock.acquire

      begin
        yield block
      ensure
        lock.release
      end
    end
  end

  def acquire(capacity = 1)
    increment!(:capacity, capacity)
  end

  def release(quantity = 1)
    transaction do
      reload
      if capacity == 1
        destroy!
      else
        decrement!(:capacity, quantity)
      end
    end
  end
end
