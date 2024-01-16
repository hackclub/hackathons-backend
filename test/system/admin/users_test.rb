require "application_system_test_case"

class Admin::UsersTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:matt)

    @user = User.first
  end

  test "searching for a user" do
    visit admin_users_path

    email_address = find_field(:email_address)
    email_address.click
    email_address.fill_in with: "nonexistent@hey.test"
    email_address.send_keys :enter

    assert_text(/not found/i)

    email_address.fill_in with: @user.email_address
    email_address.send_keys :enter

    assert_text @user.display_name
  end

  test "editing a user's name" do
    visit admin_user_path(@user)

    within("turbo-frame#name") do
      click_on "✏️"
    end

    name = find_field(:user_name)
    name.click
    name.fill_in with: "#{@user.name} 2.0"
    name.send_keys :enter

    assert_no_field :user_name
    assert_equal "#{@user.name} 2.0", @user.reload.name
  end

  test "changing a user's email address" do
    visit admin_user_path(@user)

    within("turbo-frame#email_address") do
      click_on "✏️"
    end

    email_address = find_field(:user_email_address)
    email_address.click
    email_address.fill_in with: "different@hey.test"
    email_address.send_keys :enter

    assert_no_field :user_email_address
    assert_equal @user.reload.email_address, "different@hey.test"
  end

  test "changing a user's email address to one already in use" do
    visit admin_user_path(@user)

    within("turbo-frame#email_address") do
      click_on "✏️"
    end

    email_address = find_field(:user_email_address)
    email_address.click
    email_address.fill_in with: User.second.email_address
    email_address.send_keys :enter

    assert_text(/taken/i)
    assert_field :user_email_address

    assert_not_equal @user.reload.email_address, User.second.email_address
  end
end
