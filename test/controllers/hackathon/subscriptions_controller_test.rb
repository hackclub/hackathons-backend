require "test_helper"

class Hackathon::SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should unsubscribe" do
    subscription = hackathon_subscriptions(:gary_seattle)

    get subscription.unsubscribe_url
    assert_response :success

    assert_match "You have unsubscribed", @response.body
    assert_match subscription.location, @response.body
  end

  test "should expire" do
    subscription = hackathon_subscriptions(:gary_seattle)

    unsub_url = subscription.unsubscribe_url
    expiration_at = Hackathon::Subscription::Status::UNSUBSCRIBE_EXPIRATION.from_now + 1.second

    travel_to expiration_at do
      get unsub_url
      assert_response :success

      assert_match "expired", @response.body
    end
  end

  test "should handle invalid signature" do
    subscription = hackathon_subscriptions(:gary_seattle)

    get unsubscribe_subscription_url(subscription) # no signature
    assert_response :success

    assert_match "expired", @response.body
  end
end
