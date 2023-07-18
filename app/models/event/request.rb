class Event::Request < ApplicationRecord
  belongs_to :event

  validates :uuid, presence: true
  validates :user_agent, presence: true
  validates :ip_address, presence: true
end
