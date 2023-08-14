class Hackathons::SubscriptionsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated, only: [:index, :unsubscribe_all]
  before_action :set_user, only: [:index, :unsubscribe_all]

  # Manage subscriptions for a user.
  # GET /users/:user_id/subscriptions
  def index
    return if @expired

    @subscriptions = @user.subscriptions.active
  end

  # Unsubscribe from all subscriptions for a user.
  # GET /users/:user_id/subscriptions/unsubscribe_all
  def unsubscribe_all
    return if @expired

    @subscriptions = @user.subscriptions.active

    @unsubscribed_ids = @subscriptions.pluck(:id)
    @unsubscribe_count = @subscriptions.map(&:unsubscribe).count(true)
  end

  private

  def set_user
    # We're using signed ids here to avoid the need for authentication.
    @user = User.find_signed(params[:user_id], purpose: :manage_subscriptions)
    @expired = @user.nil?
  end
end
