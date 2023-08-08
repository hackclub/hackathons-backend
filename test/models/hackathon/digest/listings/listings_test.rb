require "test_helper"

class Hackathon::Digest::ListingsTest < ActiveSupport::TestCase
  test "create a digest with no matching listings" do
    user = User.create!(email_address: "test@example.com")
    hackathon = Hackathon::Digest.new recipient: user
    assert_not hackathon.save
  end
end
