class User < ApplicationRecord
  include Eventable

  include Authenticatable
  include Identifiable
  include Named
  include Privileged # depends on Eventable

  has_many :subscriptions, class_name: "Hackathon::Subscription", foreign_key: "subscriber_id", inverse_of: :subscriber, dependent: :destroy
end
