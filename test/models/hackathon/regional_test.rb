require "test_helper"

class Hackathon::RegionalTest < ActiveSupport::TestCase
  setup do
    @hackathon = Hackathon.new(
      name: "HQHacks",
      starts_at: Time.now,
      ends_at: 1.day.from_now,
      website: "https://hackclub.com",
      high_school_led: true,
      expected_attendees: 20,
      modality: "in_person",
      logo: active_storage_blobs(:assemble_logo),
      banner: active_storage_blobs(:assemble),
      applicant: users(:gary)
    )

    [{
      coordinates: [44.3803059, -73.2271145],
      address: "15, Falls Road, Shelburne, Chittenden County, Vermont, 05482, United States",
      house_number: "15",
      street: "Falls Road",
      city: "Shelburne",
      province: "Vermont",
      state: "Vermont",
      postal_code: "05482",
      country_code: "us"
    }].tap do |results|
      # The geocode results are the same for both lookup strings
      Geocoder::Lookup::Test.add_stub("15 Falls Road, Shelburne, Vermont", results)
      Geocoder::Lookup::Test.add_stub("15 Falls Road, VT", results)
    end
  end

  test "creating a hackathon with seperated location attributes" do
    @hackathon.street = "15 Falls Road"
    @hackathon.city = "Shelburne"
    @hackathon.province = "Vermont"

    assert @hackathon.save
    assert_equal @hackathon.street, "Falls Road"
    assert_equal @hackathon.address, "15, Falls Road, Shelburne, Chittenden County, Vermont, 05482, United States"
  end

  test "creating a hackathon with a full address" do
    @hackathon.address = "15 Falls Road, VT"

    assert @hackathon.save
    assert_equal @hackathon.province, "Vermont"
  end
end
