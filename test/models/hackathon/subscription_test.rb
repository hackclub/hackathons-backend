require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  setup do
    Geocoder::Lookup::Test.add_stub(
      "05482", [{"coordinates" => [44.3909, -73.2187]}]
    )
    Geocoder::Lookup::Test.add_stub(
      [44.3909, -73.2187],
      [
        {
          "city" => "Shelburne",
          "state" => "Vermont",
          "country_code" => "us"
        }
      ]
    )

    @user = users(:matt)
    Current.user = @user
  end

  test "subscribing to hackathons for an area" do
    assert_difference -> { Hackathon::Subscription.active_for(@user).count } do
      Hackathon::Subscription.create location_input: "05482"
    end

    assert_equal "Shelburne, Vermont, US", Hackathon::Subscription.first.location
  end

  test "subscribing for the same area" do
    assert_difference -> { Hackathon::Subscription.active_for(@user).count } do
      Hackathon::Subscription.create location_input: "05482"
    end

    assert_no_difference -> { Hackathon::Subscription.active_for(@user).count } do
      Hackathon::Subscription.create location_input: "05482"
    end
  end

  test "disabling a subscription" do
    subscription = Hackathon::Subscription.new location_input: "05482"
    assert subscription.save
    assert subscription.active?

    assert_difference -> { subscription.events.count } do
      subscription.update! status: :inactive
    end

    assert_includes subscription.events.collect(&:action), "disabled"
  end
end
