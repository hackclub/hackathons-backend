class Event < ApplicationRecord
  include Requested

  belongs_to :eventable, polymorphic: true

  belongs_to :creator, class_name: "User", optional: true
  belongs_to :target, class_name: "User", optional: true

  validates :action, presence: true

  def description
    [creator&.name, action.humanize(capitalize: false), target&.name].compact.join(" ")
  end
end
