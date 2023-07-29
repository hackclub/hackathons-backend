require "test_helper"

class Hackathon::Digest::Listings::ByLocationTest < ActiveSupport::TestCase
  setup do
    seattle = {
      "city" => "Seattle",
      "state" => "Washington",
      "country_code" => "us",
      "coordinates" => [47.6038321, -122.330062]
    }
    Geocoder::Lookup::Test.add_stub("Seattle, Washington, US", [seattle])
    Geocoder::Lookup::Test.add_stub(seattle["coordinates"], [seattle.except("coordinates")])

    washington = {
      "state" => "Washington",
      "country_code" => "us",
      "coordinates" => [47.2868352, -120.212613]
    }
    Geocoder::Lookup::Test.add_stub("Washington, US", [washington])
    Geocoder::Lookup::Test.add_stub(washington["coordinates"], [washington.except("coordinates")])

    us = {
      "country_code" => "us",
      "coordinates" => [39.7837304, -100.445882]
    }
    Geocoder::Lookup::Test.add_stub("US", [us])
    Geocoder::Lookup::Test.add_stub(us["coordinates"], [us.except("coordinates")])

    bellevue_wa = {
      "city" => "Bellevue",
      "state" => "Washington",
      "country_code" => "us",
      "coordinates" => [47.6144219, -122.192337]
    }
    Geocoder::Lookup::Test.add_stub("Bellevue, Washington, US", [bellevue_wa])
    Geocoder::Lookup::Test.add_stub(bellevue_wa["coordinates"], [bellevue_wa.except("coordinates")])

    @user = users(:gary)
  end

  test "when the user has no subscriptions it returns an empty array" do
    digest = Hackathon::Digest.create! recipient: @user

    assert_equal [], digest.listings
  end

  test "it returns hackathons in the same subscription city" do
    @user.subscriptions.create! location_input: "Seattle, Washington, US"

    hackathon_in_seattle = hackathons(:seattle_hacks)
    digest = Hackathon::Digest.create! recipient: @user

    assert_includes digest.listed_hackathons, hackathon_in_seattle
  end

  test "listing hackathons within 150 miles of a city" do
    @user.subscriptions.create! location_input: "Seattle, Washington, US"

    hackathon_near_seattle = hackathons(:bellevue_hacks).dup
    hackathon_near_seattle.assign_attributes(
      logo: active_storage_blobs(:assemble_logo), banner: active_storage_blobs(:assemble)
    )
    hackathon_near_seattle.save!

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
