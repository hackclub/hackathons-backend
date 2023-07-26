module Deliverable
  extend ActiveSupport::Concern
  extend Suppressible

  included do
    after_create_commit :deliver_later, if: :deliver_after_creation?
  end

  def deliver_later
    delivery.deliver_later
  end

  def deliver_now
    delivery.deliver_now
  end

  private

  def deliver_after_creation?
    !Deliverable.suppressed?
  end

  def delivery
    raise NotImplementedError
  end
end
