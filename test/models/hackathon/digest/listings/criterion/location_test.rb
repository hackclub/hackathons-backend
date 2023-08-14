require "test_helper"

class Hackathon::Digest::Listings::Criterion::LocationTest < ActiveSupport::TestCase
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

    Geocoder::Lookup::Test.add_stub("California, US", [{
      state: "California",
      country_code: "us",
      coordinates: [36.7014631, -118.755997]
    }])

    Geocoder::Lookup::Test.add_stub("US", [{
      country_code: "us",
      coordinates: [39.7837304, -100.445882]
    }])

    Geocoder::Lookup::Test.add_stub("Canada", [{
      country_code: "ca",
      coordinates: [61.0666922, -107.991707]
    }])

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

  test "US makes Seattle redundant" do
    # If there's a subscription to "US", then we don't need "Seattle, WA, US
    seattle = hackathon_subscriptions(:gary_seattle)
    us = @user.subscriptions.create! location_input: "US"

    location_criterion = Hackathon::Digest::Listings::Criterion::Location.new(recipient: @user)
    subscriptions = location_criterion.send(:subscriptions_to_search)

    assert_not_includes subscriptions, seattle
    assert_includes subscriptions, us
  end

  test "Washington makes Seattle redundant" do
    # If there's a subscription to "Washington, US", then we don't need "Seattle, WA, US"
    seattle = hackathon_subscriptions(:gary_seattle)
    washington = @user.subscriptions.create! location_input: "Washington, US"

    location_criterion = Hackathon::Digest::Listings::Criterion::Location.new(recipient: @user)
    subscriptions = location_criterion.send(:subscriptions_to_search)

    assert_not_includes subscriptions, seattle
    assert_includes subscriptions, washington
  end

  test "keeps subscriptions of same location significance (city)" do
    user = User.create!(name: "User without subscriptions", email_address: "no@subscriptions.test")

    bellevue = user.subscriptions.create! location_input: "Bellevue, Washington, US"
    redmond = user.subscriptions.create! location_input: "Redmond, Washington, US"

    location_criterion = Hackathon::Digest::Listings::Criterion::Location.new(recipient: user)
    subscriptions = location_criterion.send(:subscriptions_to_search)

    assert_includes subscriptions, bellevue
    assert_includes subscriptions, redmond
  end

  test "keeps subscriptions of same location significance (state)" do
    user = User.create!(name: "User without subscriptions", email_address: "no@subscriptions.test")

    washington = user.subscriptions.create! location_input: "Washington, US"
    california = user.subscriptions.create! location_input: "California, US"

    location_criterion = Hackathon::Digest::Listings::Criterion::Location.new(recipient: user)
    subscriptions = location_criterion.send(:subscriptions_to_search)

    assert_includes subscriptions, washington
    assert_includes subscriptions, california
  end

  test "keeps subscriptions of same location significance (country)" do
    user = User.create!(name: "User without subscriptions", email_address: "no@subscriptions.test")

    us = user.subscriptions.create! location_input: "US"
    canada = user.subscriptions.create! location_input: "Canada"

    location_criterion = Hackathon::Digest::Listings::Criterion::Location.new(recipient: user)
    subscriptions = location_criterion.send(:subscriptions_to_search)

    assert_includes subscriptions, us
    assert_includes subscriptions, canada
  end
end
