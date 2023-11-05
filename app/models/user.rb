class User < ApplicationRecord
  include Eventable

  include Authenticatable
  include Identifiable
  include Named
  include Privileged # depends on Eventable

  has_many :subscriptions, class_name: "Hackathon::Subscription", inverse_of: :subscriber, dependent: :destroy
  has_many :digests, class_name: "Hackathon::Digest", inverse_of: :recipient, dependent: :destroy
end
