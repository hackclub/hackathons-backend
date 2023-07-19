require "test_helper"

class Hackathon::RegionalTest < ActiveSupport::TestCase
  test "creating a hackathon with seperated location attributes" do
    hackathon = Hackathon.new name: "HQHacks", starts_at: Time.now, ends_at: 1.day.from_now, applicant: users(:gary)

    Geocoder::Lookup::Test.add_stub(
      "15 Falls Road, Shelburne, Vermont", [{"coordinates" => [44.3803059, -73.2271145]}]
    )

    hackathon.street = "15 Falls Road"
    hackathon.city = "Shelburne"
    hackathon.province = "Vermont"

    Geocoder::Lookup::Test.add_stub(
      [44.3803059, -73.2271145],
      [
        {
          "address" => "15, Falls Road, Shelburne, Chittenden County, Vermont, 05482, United States",
          "house_number" => "15",
          "street" => "Falls Road",
          "city" => "Shelburne",
          "state" => "Vermont",
          "postal_code" => "05482",
          "country_code" => "US"
        }
      ]
    )

    assert hackathon.save
    assert_equal hackathon.street, "15 Falls Road"
    assert_equal hackathon.address, "15, Falls Road, Shelburne, Chittenden County, Vermont, 05482, United States"
  end

  test "creating a hackathon with a full address" do
    hackathon = Hackathon.new name: "HQHacks", starts_at: Time.now, ends_at: 1.day.from_now, applicant: users(:gary)

    Geocoder::Lookup::Test.add_stub(
      "15 Falls Road, VT", [{"coordinates" => [44.3803059, -73.2271145]}]
    )
    Geocoder::Lookup::Test.add_stub(
      [44.3803059, -73.2271145],
      [
        {
          "address" => "15, Falls Road, Shelburne, Chittenden County, Vermont, 05482, United States",
          "house_number" => "15",
          "street" => "Falls Road",
          "city" => "Shelburne",
          "state" => "Vermont",
          "postal_code" => "05482",
          "country_code" => "US"
        }
      ]
    )

    hackathon.address = "15 Falls Road, VT"

    assert hackathon.save
    assert_equal hackathon.province, "Vermont"
  end
end
