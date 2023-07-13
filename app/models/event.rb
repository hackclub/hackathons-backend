class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true

  belongs_to :creator, class_name: "User", optional: true
  belongs_to :target, class_name: "User", optional: true

  validates :action, presence: true

  def description
    if creator && !target
      "#{action.humanize(capitalize: false)} by #{creator.name}" # e.g. (hackathon) "approved by Matt" vs "Matt removed X" ∨∨∨
    else
      [creator.name, action.humanize(capitalize: false), target.name].compact.join(" ")
    end
  end
end
