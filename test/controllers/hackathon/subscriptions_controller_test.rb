require "test_helper"

class Hackathon::SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subscription = hackathon_subscriptions(:gary_seattle)
  end

  test "should unsubscribe" do
    get @subscription.unsubscribe_url
    assert_response :success

    assert_match "You have unsubscribed", @response.body
    assert_match @subscription.location, @response.body
  end

  test "should expire" do
    unsub_url = @subscription.unsubscribe_url
    expiration_at = Hackathon::Subscription::Status::UNSUBSCRIBE_EXPIRATION.from_now + 1.second

    travel_to expiration_at do
      get unsub_url
      assert_response :success

      assert_match "expired", @response.body
    end
  end

  test "should handle invalid signature" do
    get unsubscribe_subscription_url(@subscription) # no signature
    assert_response :success

    assert_match "expired", @response.body
  end
end
