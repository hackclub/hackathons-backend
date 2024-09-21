require "capybara/cuprite"
require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, screen_size: [1500, 3000], options: {headless: :new, pending_connection_errors: false, js_errors: true}

  def sign_in_as(user)
    visit sign_in_path

    fill_in :email_address, with: user.email_address
    click_on "Send Sign In Link"
    assert_text(/sent/i)

    visit new_session_path(auth_token: user.authentications.last.token)
  end

  def visit(path)
    super
    find 'body[data-stimulus-ready="true"]'
  end
end
