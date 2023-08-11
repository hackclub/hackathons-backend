require "test_helper"

class Hackathon::Digest::Listings::Criterion::LocationTest < ActiveSupport::TestCase
  setup do
    seattle = {
      "city" => "Seattle",
      "state" => "Washington",
      "country_code" => "us",
      "coordinates" => [47.6038321, -122.330062]
    }
    Geocoder::Lookup::Test.add_stub("Seattle, Washington, US", [seattle])

    washington = {
      "state" => "Washington",
      "country_code" => "us",
      "coordinates" => [47.2868352, -120.212613]
    }
    Geocoder::Lookup::Test.add_stub("Washington, US", [washington])

    us = {
      "country_code" => "us",
      "coordinates" => [39.7837304, -100.445882]
    }
    Geocoder::Lookup::Test.add_stub("US", [us])

    @user = users(:gary)
  end

  test "it returns hackathons in the same subscription city" do
    subscription = hackathon_subscriptions(:gary_seattle)
    @user = subscription.subscriber

    hackathon_in_seattle = hackathons(:seattle_hacks)
    digest = Hackathon::Digest.create! recipient: @user

    assert_includes digest.listed_hackathons, hackathon_in_seattle
  end

  test "listing hackathons within 150 miles of a city" do
    subscription = hackathon_subscriptions(:gary_seattle)
    @user = subscription.subscriber

    hackathon_near_seattle = hackathons(:bellevue_hacks)

    digest = Hackathon::Digest.create! recipient: @user

    assert_includes digest.listed_hackathons, hackathon_near_seattle
  end

  test "listing hackathons in the same state" do
    @user.subscriptions.create! location_input: "Washington, US"

    hackathon_in_washington = hackathons(:seattle_hacks)
    digest = Hackathon::Digest.create! recipient: @user

    assert_includes digest.listed_hackathons, hackathon_in_washington
  end

  test "listing hackathons in the same country" do
    @user.subscriptions.create! location_input: "US"

    hackathon_in_us = hackathons(:seattle_hacks)
    digest = Hackathon::Digest.create! recipient: @user

    assert_includes digest.listed_hackathons, hackathon_in_us
  end
end
