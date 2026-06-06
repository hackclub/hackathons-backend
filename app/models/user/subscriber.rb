module User::Subscriber
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, class_name: "Hackathon::Subscription", inverse_of: :subscriber, dependent: :destroy
    has_many :active_subscriptions, -> { active }, class_name: "Hackathon::Subscription", inverse_of: :subscriber

    has_many :digests, class_name: "Hackathon::Digest", inverse_of: :recipient, dependent: :destroy
    has_many :digests_in_past_week, -> { where created_at: 6.days.ago... }, class_name: "Hackathon::Digest", inverse_of: :recipient
  end
end
