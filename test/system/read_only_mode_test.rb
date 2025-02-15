require "application_system_test_case"

class ReadOnlyModeTest < ApplicationSystemTestCase
  setup do
    ENV["READ_ONLY_MODE"] = "true"
  end

  teardown do
    ENV.delete "READ_ONLY_MODE"
  end

  test "signing in with read only mode" do
    visit sign_in_path
    assert_no_text(/read only/i)

    fill_in :email_address, with: users(:matt).email_address
    click_on "Send Sign In Link"

    assert_text(/read only/i)
    assert_not User::Authentication.exists? user: users(:matt)
  end

  test "default behavior takes priority" do
    assert_raises ReadOnlyModeError do
      users(:matt).update! name: "different"
    end

    users(:matt).readonly!

    assert_raises ActiveRecord::ReadOnlyRecord do
      users(:matt).update! name: "different"
    end
  end
end
