class Hackathon::Subscriptions::BulkController < ApplicationController
  skip_before_action :redirect_if_unauthenticated, only: [:update, :destroy]

  before_action :set_user
  before_action :set_subscriptions

  # Marking subscriptions as active. Used for undoing an "Unsubscribe from all".
  # PUT /users/:user_id/subscriptions/bulk
  def update
    @count = @subscriptions.map(&:resubscribe!).count(true)

    redirect_to Hackathon::Subscription.manage_subscriptions_url_for(@user),
      notice: "Resubscribed to #{@count} #{"locations".pluralize(@count)}."
  end

  # Marking subscriptions as inactive.
  # DELETE /users/:user_id/subscriptions/bulk
  def destroy
    @count = @subscriptions.map(&:unsubscribe!).count(true)

    redirect_to Hackathon::Subscription.manage_subscriptions_url_for(@user),
      notice: "Unsubscribed from #{@count} #{"locations".pluralize(@count)}."
  end

  private

  def set_user
    # We're using signed ids here to avoid the need for authentication.
    @user = User.find_signed!(params[:user_id], purpose: :manage_subscriptions)
  end

  def set_subscriptions
    @subscriptions = @user.subscriptions.where(id: params[:ids])
  end
end
