require "application_system_test_case"

class Admin::UsersTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:matt)

    @user = User.first
  end

  test "searching for a user" do
    visit admin_users_path

    fill_in :email_address, with: "nonexistent@hey.com\n"
    assert_text(/not found/i)

    fill_in :email_address, with: "#{@user.email_address}\n"
    assert_redirected_to admin_user_path(@user)
  end

  test "editing a user's name" do
    visit admin_user_path(@user)

    within("#name") do
      click_on "✏️"
    end

    assert_selector "input[type=text]#user_name"

    fill_in :user_name, with: "#{@user.name} 2.0\n"

    assert_no_selector "input[type=text]#user_name"

    assert @user.reload.name =~ /2\.0/
  end

  test "changing a user's email address" do
    visit admin_user_path(@user)

    within("#email_address") do
      click_on "✏️"
    end

    assert_selector "input[type=email]#user_email_address"

    fill_in :user_email_address, with: "different@hey.com\n"

    assert_no_selector "input[type=email]#user_email_address"

    assert_equal @user.reload.email_address, "different@hey.com"
  end

  test "changing a user's email address to one already in use" do
    visit admin_user_path(@user)

    within("#email_address") do
      click_on "✏️"
    end

    assert_selector "input[type=email]#user_email_address"

    fill_in :user_email_address, with: "#{User.second.email_address}\n"

    assert_selector "input[type=email]#user_email_address"

    assert_text(/taken/i)
  end
end
