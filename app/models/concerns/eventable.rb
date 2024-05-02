module Eventable
  extend ActiveSupport::Concern

  included do
    has_many :events, as: :eventable, dependent: :destroy

    after_create { record :created }
  end

  private

  def record(action, target = nil, by: Current.user, **details)
    events.create!(action:, target:, details:, creator: by)
  end
end
