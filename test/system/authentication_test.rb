require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  setup do
    @user = users(:matt)
  end

  test "requesting a sign in link" do
    ApplicationMailer.deliveries.clear
    visit sign_in_path

    fill_in :email_address, with: @user.email_address
    click_on "Send Sign In Link"

    assert_text(/sent/i)
    assert_text(@user.email_address)

    authentication = @user.authentications.last
    assert authentication
    assert_not authentication&.succeeded?

    assert_equal 1, UserMailer.deliveries.count

    delivery = UserMailer.deliveries.first

    assert_includes delivery&.to, @user.email_address
    assert_includes delivery&.text_part&.body, new_session_path(auth_token: authentication&.token)
    assert_includes delivery&.html_part&.body, new_session_path(auth_token: authentication&.token)
  end

  test "using an invalid link" do
    assert_no_difference -> { @user.sessions.count } do
      visit new_session_path(auth_token: "1234")
    end

    assert_current_path sign_in_path
  end

  test "using an expired link" do
    authentication = @user.authentications.create!

    travel 1.day

    assert_no_difference -> { @user.sessions.count } do
      visit new_session_path(auth_token: authentication.token)
    end

    assert_not authentication.succeeded?
    assert_equal "rejected", authentication.events&.last&.action
    assert_equal "expired", authentication.events&.last&.details&.dig("reason")

    assert_current_path sign_in_path
  end

  test "as a non-admin" do
    user = users(:peasant_matt)
    authentication = user.authentications.create!

    assert_no_difference -> { user.sessions.count } do
      visit new_session_path(auth_token: authentication.token)
    end

    assert_not authentication.succeeded?
    assert_equal "rejected", authentication.events&.last&.action
    assert_equal "non_admin", authentication.events&.last&.details&.dig("reason")

    assert_no_current_path sign_in_path
  end

  test "using a valid link" do
    authentication = @user.authentications.create!

    assert_difference -> { @user.sessions.count } do
      visit new_session_path(auth_token: authentication.token)
    end

    assert authentication.succeeded?

    assert_no_current_path sign_in_path
  end
end
