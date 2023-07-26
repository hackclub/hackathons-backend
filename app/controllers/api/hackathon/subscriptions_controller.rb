class Api::Hackathon::SubscriptionsController < Api::BaseController
  def create
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by!(email_address: params.require(:email))
      @subscription = Hackathon::Subscription.create!(
        location_input: params.require(:location),
        subscriber: user
      )
    end

    render partial: "api/hackathons/subscriptions/subscription", locals: {subscription: @subscription}
  end
end
