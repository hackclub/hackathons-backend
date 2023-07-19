require "test_helper"

class HackathonTest < ActiveSupport::TestCase
  test "creating a hackathon with invalid dates" do
    hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.ago,
      applicant: users(:gary)
    )

    assert_not hackathon.save
  end

  test "creating a hackathon" do
    hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.from_now,
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
