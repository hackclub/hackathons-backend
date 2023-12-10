class Event::Request < ApplicationRecord
  belongs_to :event

  validates :uuid, :user_agent, :ip_address, presence: true

  before_validation :set_from_current, on: :create

  private

  def set_from_current
    self.uuid = Current.request_id,
    self.user_agent = Current.user_agent,
    self.ip_address = Current.ip_address
  end
end
