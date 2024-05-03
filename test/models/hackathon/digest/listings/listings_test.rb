require "test_helper"

class Hackathon::Digest::ListingsTest < ActiveSupport::TestCase
  setup do
    Geocoder::Lookup::Test.add_stub("Seattle, Washington, US", [{
      city: "Seattle",
      state: "Washington",
      country_code: "us",
      coordinates: [47.6038321, -122.330062]
    }])

    Geocoder::Lookup::Test.add_stub("Bellevue, Washington, US", [{
      city: "Bellevue",
      state: "Washington",
      country_code: "us",
      coordinates: [47.6144219, -122.192337]
    }])

    Geocoder::Lookup::Test.add_stub("Redmond, Washington, US", [{
      city: "Redmond",
      state: "Washington",
      country_code: "us",
      coordinates: [46.6988644, -120.4409335]
    }])

    Geocoder::Lookup::Test.add_stub("Washington, US", [{
      state: "Washington",
      country_code: "us",
      coordinates: [47.2868352, -120.212613]
    }])

    Geocoder::Lookup::Test.add_stub("US", [{
      country_code: "us",
      coordinates: [39.7837304, -100.445882]
    }])

    @user = users(:gary)
  end

  test "create a digest with no matching listings" do
    user = User.create!(email_address: "test@example.com")
    hackathon = Hackathon::Digest.new recipient: user
    assert_not hackathon.save
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
