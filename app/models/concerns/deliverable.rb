module Deliverable
  extend ActiveSupport::Concern
  extend Suppressible

  included do
    after_create_commit :deliver_later, unless: -> { Deliverable.suppressed? }
  end

  def deliver_later
    delivery.deliver_later
  end

  def deliver_now
    delivery.deliver_now
  end

  def delivery
    raise NotImplementedError
  end
end
