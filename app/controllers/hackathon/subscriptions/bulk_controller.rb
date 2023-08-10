class Hackathon::Subscriptions::BulkController < ApplicationController
  skip_before_action :redirect_if_unauthenticated, only: [:update, :destroy]

  before_action :set_user
  before_action :set_subscriptions

  # Marking subscriptions as active. Used for undoing an "Unsubscribe from all".
  # PUT /users/:user_id/subscriptions/bulk
  def update
    @subscriptions.each(&:resubscribe!)
    redirect_to Hackathon::Subscription.manage_subscriptions_url_for @user
  end

  # Marking subscriptions as inactive.
  # DELETE /users/:user_id/subscriptions/bulk
  def destroy
    @subscriptions.each(&:unsubscribe!)
    redirect_to Hackathon::Subscription.manage_subscriptions_url_for @user
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
