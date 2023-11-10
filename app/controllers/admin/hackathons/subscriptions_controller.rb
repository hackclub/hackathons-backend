class Admin::Hackathons::SubscriptionsController < Admin::BaseController
  before_action :set_subscription

  def destroy
    @subscription.unsubscribe
    redirect_to admin_user_path(@subscription.subscriber)
  end

  private

  def set_subscription
    @subscription = Hackathon::Subscription.find(params[:id])
  end
end
