class Hackathons::SwagRequestDeliveryJob < ApplicationJob
  def perform(swag_request)
    swag_request.deliver_if_pertinent
  end
end
