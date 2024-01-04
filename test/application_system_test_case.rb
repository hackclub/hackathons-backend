ENV["PARALLEL_WORKERS"] ||= "0"

require "capybara/cuprite"
require "test_helper"

Capybara.default_max_wait_time = 5.seconds

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, screen_size: [1400, 1400], options: {headless: :new, js_errors: true}

  def sign_in_as(user)
    visit sign_in_path

    fill_in :email_address, with: user.email_address
    click_on "Send Sign In Link"
    assert_flash_notice(/sent/i)

    visit new_session_path(auth_token: user.authentications.last.token)
  end

  def assert_flash_notice(message)
    assert_text(:all, message)
  end

  def visit(path)
    super(path)
    find 'body[data-stimulus-ready="true"]'
  end
end
