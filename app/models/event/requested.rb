module Event::Requested
  extend ActiveSupport::Concern

  included do
    has_one :request, dependent: :destroy

    before_create :attach_request
  end

  private

  def attach_request
    build_request(
      uuid: Current.request_id,
      user_agent: Current.user_agent,
      ip_address: Current.ip_address
    )
  end
end
