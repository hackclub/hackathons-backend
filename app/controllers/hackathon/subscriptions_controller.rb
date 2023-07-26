class Hackathon::SubscriptionsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated, only: [:unsubscribe]

  def unsubscribe
    @subscription = Hackathon::Subscription.find_signed(params[:id], purpose: :unsubscribe)
    return unless @subscription

    @unsubscribed = @subscription.update!(status: :inactive)

    @subscriber = @subscription.subscriber
    @other_subscriptions = Hackathon::Subscription.active_for(@subscriber)
  end
end
