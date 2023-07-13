require "test_helper"

class User::PrivilegeTest < ActiveSupport::TestCase
  test "promoting a user" do
    user = users(:peasant_matt)
    user.promote_to_admin

    assert user.admin?
  end

  test "promoting a user creates an event" do
    user = users(:peasant_matt)
    user.promote_to_admin

    assert user.events&.last&.action == "promoted_to_admin"
  end

  test "demoting a user" do
    user = users(:matt)
    user.demote_from_admin

    assert_not user.admin?
  end

  test "demoting a user creates an event" do
    user = users(:matt)
    user.demote_from_admin

    assert user.events&.last&.action == "demoted_from_admin"
  end
end
