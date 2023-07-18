require "application_system_test_case"

class AuthenticationFlowTest < ApplicationSystemTestCase
  test "requesting a sign in link" do
    visit sign_in_path

    fill_in :email_address, with: "matt7@hey.test"
    click_on "Send Sign In Link"

    assert User.where(email_address: "matt7@hey.test").exists?

    assert_text(/sent/i)
    assert_text(/matt7@hey\.test/)
  end

  test "using an invalid link" do
    user = users(:matt)
    authentication = user.authentications.create!

    travel 1.day

    visit new_session_path(auth_token: authentication.token)

    assert_current_path sign_in_path
  end

  test "using a valid link" do
    user = users(:matt)
    authentication = user.authentications.create!

    assert_difference -> { user.sessions.count } do
      visit new_session_path(auth_token: authentication.token)
    end

    assert_no_current_path sign_in_path
  end
end
