require "test_helper"

class HackathonTest < ActiveSupport::TestCase
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

  test "creating a hackathon" do
    hackathon = Hackathon.new(
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

    assert hackathon.save
  end

  test "creating a hackathon without an applicant" do
    hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.from_now
    )

    assert_not hackathon.save
  end
end
