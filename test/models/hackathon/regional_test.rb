require "test_helper"

class Hackathon::RegionalTest < ActiveSupport::TestCase
  test "creating a hackathon with a location" do
    hackathon = Hackathon.new name: "HQHacks", starts_at: Time.now, ends_at: 1.day.from_now

    Geocoder::Lookup::Test.add_stub(
      "15 Falls Road, VT", [{"coordinates" => [44.3803059, -73.2271145]}]
    )
    Geocoder::Lookup::Test.add_stub(
      [44.3803059, -73.2271145],
      [
        {
          "address" => "15, Falls Road, Shelburne, Chittenden County, Vermont, 05482, United States",
          "city" => "Shelburne",
          "state" => "Vermont",
          "country_code" => "US",
          "postal_code" => "05482"
        }
      ]
    )

    hackathon.address = "15 Falls Road, VT"

    assert hackathon.save
    assert_equal hackathon.state, "Vermont"
  end
end
