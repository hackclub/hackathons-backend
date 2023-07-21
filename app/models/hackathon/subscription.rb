class Hackathon::Subscription < ApplicationRecord
  include Eventable

  include Status # depends on Eventable

  include Regional # depends on Status

  belongs_to :subscriber, class_name: "User", default: -> { Current.user }
end
