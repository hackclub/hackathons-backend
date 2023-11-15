require "test_helper"

class User::PrivilegeTest < ActiveSupport::TestCase
  test "promoting a user" do
    user = users(:peasant_matt)
    assert_not user.admin?

    user.update admin: true

    assert user.admin?
    assert_equal "promoted_to_admin", user.events.last&.action
  end

  test "demoting a user" do
    user = users(:matt)
    assert user.admin?

    user.update admin: false

    assert_not user.admin?
    assert_equal "demoted_from_admin", user.events.last&.action
  end
end
