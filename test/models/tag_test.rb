require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "creating a tag without a name" do
    assert_not Tag.new.save
  end

  test "creating a tag" do
    assert Tag.new(name: "test").save
  end
end
