class Api::SubscriptionsController < ApiController
  def create
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by!(email_address: params.require(:email))
      @subscription = Hackathon::Subscription.create!(
        location_input: params.require(:location),
        subscriber: user
      )
    end
  end
end
