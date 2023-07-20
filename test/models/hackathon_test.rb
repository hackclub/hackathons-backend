require "test_helper"

class HackathonTest < ActiveSupport::TestCase
  setup do
    # This contains the bare basics of an instantiable Hackathon object
    @hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.from_now,
      website: "https://hackclub.com",
      high_school_led: true,
      expected_attendees: 100,
      modality: "in_person",
      financial_assistance: true,
      logo: active_storage_blobs(:assemble_logo),
      banner: active_storage_blobs(:assemble),
      applicant: users(:gary)
    )
  end

  test "creating a hackathon" do
    assert @hackathon.save
  end

  test "creating a hackathon with invalid dates" do
    hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.ago,
      website: "https://hackclub.com",
      high_school_led: true,
      expected_attendees: 100,
      modality: "in_person",
      financial_assistance: true,
      logo: active_storage_blobs(:assemble_logo),
      banner: active_storage_blobs(:assemble),
      applicant: users(:gary)
    )

    assert_not hackathon.save
  end

  test "creating a hackathon without an applicant" do
    hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.from_now
    )

    assert_not hackathon.save
  end

  test "create a hackathon with swag mailing address" do
    @hackathon.swag_mailing_address_attributes = {
      line1: "123 Test St",
      city: "Test City",
      province: "Test State",
      country_code: "US"
    }

    assert @hackathon.save
    assert @hackathon.requested_swag?
  end

  test "#requested_swag? without swag mailing address" do
    assert_not @hackathon.requested_swag?
  end
end
