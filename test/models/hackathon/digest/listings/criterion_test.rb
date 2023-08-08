require "test_helper"

class Hackathon::Digest::Listings::CriterionTest < ActiveSupport::TestCase
  test "is not instantiatable" do
    user = users(:gary)
    assert_raises NotImplementedError, "Criterion is an abstract base class" do
      Hackathon::Digest::Listings::Criterion.new(recipient: user)
    end
  end
end
