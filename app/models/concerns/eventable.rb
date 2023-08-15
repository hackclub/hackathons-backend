module Eventable
  extend ActiveSupport::Concern

  included do
    has_many :events, as: :eventable, dependent: :destroy

    before_create { record(:created) }
  end

  private

  def record(action, target = nil, by: Current.user, **details)
    attrs = {action: action, target: target, creator: by, details: details}

    if new_record?
      events.build attrs
    else
      events.create! attrs
    end
  end
end
