class Hackathon::Subscription < ApplicationRecord
  include Eventable

  include Regional
  include Status # depends on Eventable

  belongs_to :subscriber, class_name: "User", default: -> { Current.user }
end
