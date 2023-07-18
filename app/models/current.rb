class Current < ActiveSupport::CurrentAttributes
  attribute :request_id, :user_agent, :ip_address
  attribute :user, :session

  def session=(session)
    super
    self.user = session&.user
  end
end
