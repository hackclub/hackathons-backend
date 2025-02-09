class Hackathons::SubscriptionsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user

  def index
    return if @expired

    @subscriptions = @user.subscriptions.active
  end

  def unsubscribe_all
    return if @expired

    @subscriptions = @user.subscriptions.active

    @unsubscribe_count = @subscriptions.map(&:unsubscribe).count(true)
  end

  private

  def set_user
    @user = User.find_signed(params[:user_id], purpose: :manage_subscriptions)
    @expired = @user.nil?
  end
end
