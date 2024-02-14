module Hackathon::SwagRequest::Delivered
  extend ActiveSupport::Concern
  extend Suppressible

  def deliver_later_if_pertinent(wait: nil)
    Hackathons::SwagRequestDeliveryJob.set(wait:).perform_later(self) if pertinent? && !Delivered.suppressed?
  end

  def deliver_if_pertinent
    HackathonMailer.with(hackathon:).swag_request.deliver if pertinent? && !Delivered.suppressed?
    touch :delivered_at
  end

  private

  def pertinent?
    hackathon.approved? && !delivered?
  end

  def delivered?
    delivered_at
  end
end
