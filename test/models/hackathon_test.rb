require "test_helper"

class HackathonTest < ActiveSupport::TestCase
  test "creating a hackathon with invalid dates" do
    hackathon = Hackathon.new name: "TestHacks", starts_at: Time.now, ends_at: 2.days.ago

    assert_not hackathon.save
  end

  test "creating a hackathon" do
    hackathon = Hackathon.new name: "TestHacks", starts_at: Time.now, ends_at: 2.days.from_now

    assert hackathon.save
  end
end
