require "application_system_test_case"

class Hackathon::SubscriptionsTest < ApplicationSystemTestCase
  setup do
    seattle = {
      "city" => "Seattle",
      "state" => "Washington",
      "country_code" => "us",
      "coordinates" => [47.6038321, -122.330062]
    }
    Geocoder::Lookup::Test.add_stub("Seattle, Washington, US", [seattle])
    Geocoder::Lookup::Test.add_stub(seattle["coordinates"], [seattle.except("coordinates")])

    @subscriber = users(:gary)
    @subscription = Hackathon::Subscription.find_or_create_by!(
      subscriber: @subscriber,
      city: "Seattle",
      province: "Washington",
      country_code: "US",
      status: :active
    )
  end

  test "managing subscriptions" do
    visit Hackathon::Subscription.manage_subscriptions_url_for @subscriber
    assert_selector "h1", text: "Manage Subscriptions"
  end

  test "invalid manage subscriptions link" do
    visit user_subscriptions_url @subscriber
    assert_text "expired"
  end

  test "unsubscribe all" do
    visit Hackathon::Subscription.unsubscribe_all_url_for @subscriber
    assert_empty @subscriber.subscriptions.active
  end
end
