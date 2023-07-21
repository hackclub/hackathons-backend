module Deliverable
  extend ActiveSupport::Concern
  extend Suppressible

  included do
    after_create_commit :deliver_later, unless: -> { Deliverable.suppressed? }
  end

  def deliver_later
    job = delivery.deliver_later

    if respond_to?(:record)
      record(:delivery_enqueued, sidekiq_job_id: job.provider_job_id)
    end
  end

  def deliver_now
    delivery.deliver_now

    if respond_to?(:record)
      record(:sent, recipient_email_address: delivery.to)
    end
  end

  def delivery
    raise NotImplementedError
  end
end
