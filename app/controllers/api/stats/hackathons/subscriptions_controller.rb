class Api::Stats::Hackathons::SubscriptionsController < Api::BaseController
  def index
    @subscriptions = Hackathon::Subscription.active
  end
end
