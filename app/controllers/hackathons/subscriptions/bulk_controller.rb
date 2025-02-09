class Hackathons::Subscriptions::BulkController < ApplicationController
  allow_unauthenticated_access

  before_action :set_user
  before_action :set_subscriptions

  def update
    @count = @subscriptions.map(&:resubscribe).count(true)

    redirect_to Hackathon::Subscription.manage_subscriptions_url_for(@user),
      notice: "Resubscribed to #{@count} #{"locations".pluralize(@count)}."
  end

  def destroy
    @count = @subscriptions.map(&:unsubscribe).count(true)

    redirect_to Hackathon::Subscription.manage_subscriptions_url_for(@user),
      notice: "Unsubscribed from #{@count} #{"locations".pluralize(@count)}."
  end

  private

  def set_user
    @user = User.find_signed!(params[:user_id], purpose: :manage_subscriptions)
  end

  def set_subscriptions
    @subscriptions = @user.subscriptions.where(id: params[:ids])
  end
end
