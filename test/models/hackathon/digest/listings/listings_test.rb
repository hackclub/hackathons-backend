require "test_helper"

class Hackathon::Digest::ListingsTest < ActiveSupport::TestCase
  test "creating a digest for user without subscriptions" do
    user = User.create!(email_address: "test@example.com")
    assert_raises ActiveRecord::RecordInvalid, "Should raise error due to listings being empty" do
      Hackathon::Digest.create! recipient: user
    end
  end
end
