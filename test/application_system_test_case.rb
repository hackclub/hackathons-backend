ENV["PARALLEL_WORKERS"] ||= "0"

require "test_helper"

Capybara.default_max_wait_time = 5.seconds

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def sign_in_as(user)
    visit sign_in_path

    fill_in :email_address, with: user.email_address
    click_on "Send Sign In Link"
    assert_text(/sent/i)

    visit new_session_path(auth_token: user.authentications.last.token)
  end
end
