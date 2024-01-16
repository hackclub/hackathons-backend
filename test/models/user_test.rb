require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "creating a user" do
    user = User.new name: "Valid User", email_address: "user@hey.test"
    assert user.save
  end

  test "creating a user without required fields" do
    assert_not User.new.save
  end
end
