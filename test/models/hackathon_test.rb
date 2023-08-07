require "test_helper"

class HackathonTest < ActiveSupport::TestCase
  setup do
    Current.user = users(:gary)

    @hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.from_now,
      website: "https://hackclub.com",
      expected_attendees: 100,
      modality: :in_person
    )
  end

  test "creating a hackathon" do
    assert @hackathon.save
    assert_equal users(:gary), @hackathon.applicant
  end

  test "creating a hackathon with invalid dates" do
    hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.ago,
      website: "https://hackclub.com",
      expected_attendees: 100,
      modality: :in_person
    )

    assert_not hackathon.save

    hackathon.ends_at = 2.days.from_now

    assert hackathon.save
  end

  test "creating a hackathon without an applicant" do
    Current.user = nil

    hackathon = Hackathon.new(
      name: "TestHacks",
      website: "https://hackclub.com",
      starts_at: Time.now,
      ends_at: 2.days.from_now
    )

    assert_not hackathon.save

    Current.user = users(:gary)

    assert hackathon.save
  end

  test "creating a hackathon wanting swag mailed" do
    assert_not @hackathon.requested_swag?

    @hackathon.swag_mailing_address_attributes = {
      line1: "123 Test St",
      city: "Test City",
      province: "Test State",
      country_code: "US"
    }

    assert @hackathon.save
    assert @hackathon.requested_swag?
  end
end
