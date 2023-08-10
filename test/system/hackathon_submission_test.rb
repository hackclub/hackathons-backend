require "application_system_test_case"

class HackathonSubmissionTest < ApplicationSystemTestCase
  setup do
    Geocoder::Lookup::Test.add_stub(
      "760 Market St, San Francisco, CA", [{"coordinates" => [37.7866671, -122.40505]}]
    )

    Geocoder::Lookup::Test.add_stub(
      [37.7866671, -122.40505],
      [{
        "address" => "760 Market Street, San Francisco, California",
        "house_number" => "760",
        "street" => "Market Street",
        "city" => "San Francisco",
        "state" => "California",
        "postal_code" => "94102",
        "country_code" => "US"
      }]
    )
  end

  test "submitting a hackathon" do
    assert_not Current.user
    assert_not User.where(email_address: "not.a.user.yet@hey.test").exists?

    visit new_hackathons_submission_path

    fill_in "Hackathon Name", with: "Assemble"
    fill_in "Website", with: "https://assemble.hackclub.com"
    fill_in "Email address", with: "not.a.user.yet@hey.test"

    attach_file "Logo", Rails.root.join("test/fixtures/files/assemble_logo.png")
    attach_file "Banner", Rails.root.join("test/fixtures/files/assemble.png")

    fill_in "Start date", with: 1.month.from_now
    fill_in "End date", with: 1.month.from_now + 2.days

    fill_in "Location", with: "760 Market St, San Francisco, CA"

    fill_in "Expected attendees", with: 100

    check :hackathon_offers_financial_assistance

    assert_difference -> { Hackathon.count } do
      click_on "Submit for Review"
      assert_text(/submitted/i)
    end

    assert User.where(email_address: "not.a.user.yet@hey.test").exists?

    assert_equal "Assemble", Hackathon.last.name
    assert_not Hackathon.last.requested_swag?
  end

  test "submitting a hackathon wanting swag" do
    visit new_hackathons_submission_path

    fill_in "Hackathon Name", with: "Assemble"
    fill_in "Website", with: "https://assemble.hackclub.com"
    fill_in "Email address", with: "not.a.user.yet@hey.test"

    attach_file "Logo", Rails.root.join("test/fixtures/files/assemble_logo.png")
    attach_file "Banner", Rails.root.join("test/fixtures/files/assemble.png")

    fill_in "Start date", with: 1.month.from_now
    fill_in "End date", with: 1.month.from_now + 2.days

    fill_in "Location", with: "760 Market St, San Francisco, CA"

    fill_in "Expected attendees", with: 100

    check :hackathon_offers_financial_assistance

    assert_no_field "Street" # hidden swag mailing address fields

    check :hackathon_requested_swag

    fill_in "Street", with: "760 Market St"
    fill_in "City", with: "San Francisco"
    fill_in "State/Province", with: "CA"
    # country dropdown is on US by default

    assert_difference -> { Hackathon.count } do
      click_on "Submit for Review"
      assert_text(/submitted/i)
    end

    assert Hackathon.last.requested_swag?
  end
end
