require "application_system_test_case"

class HackathonSubmissionTest < ApplicationSystemTestCase
  setup do
    Geocoder::Lookup::Test.add_stub(
      "760 Market St, San Francisco, CA, 94102, US", [{
        coordinates: [37.7866671, -122.40505],
        address: "760, Market Street, Union Square, San Francisco, CAL Fire Northern Region, California, 94102, United States",
        house_number: "760",
        street: "Market Street",
        city: "San Francisco",
        province: "California",
        state: "California",
        postal_code: "94102",
        country_code: "us"
      }]
    )
  end

  test "submitting a hackathon" do
    assert_not Current.user
    assert_not User.where(email_address: "not.a.user.yet@hey.test").exists?

    visit new_hackathons_submission_path

    fill_in "Your name", with: "Gary"
    fill_in "Email address", with: "not.a.user.yet@hey.test"
    select "No", from: "Are you a high schooler?"

    fill_in "Name of the hackathon", with: "Assemble"
    fill_in "Start date", with: 1.month.from_now.beginning_of_minute
    fill_in "End date", with: (1.month.from_now + 2.days).beginning_of_minute
    fill_in "Website", with: "https://assemble.hackclub.com"

    attach_file "Logo", Rails.root.join("test/fixtures/files/assemble_logo.jpg")
    attach_file "Banner", Rails.root.join("test/fixtures/files/assemble.jpg")

    select "In Person", from: "Where is the hackathon taking place?"
    fill_in "Street", with: "760 Market St"
    fill_in "City", with: "San Francisco"
    fill_in "State/Province", with: "CA"
    fill_in "ZIP/Postal Code", with: "94102"
    select "United States", from: "Country"

    fill_in :hackathon_expected_attendees, with: 100

    select "Yes", from: :hackathon_offers_financial_assistance
    select "No", from: :requested_swag

    click_on "Submit for Review"
    assert_text(/submitted/i)

    assert User.where(email_address: "not.a.user.yet@hey.test").exists?

    assert_equal "Assemble", Hackathon.last.name
    assert_not Hackathon.last.requested_swag?
  end

  test "submitting a hackathon wanting swag" do
    visit new_hackathons_submission_path

    fill_in "Your name", with: "Gary"
    fill_in "Email address", with: "not.a.user.yet@hey.test"
    select "No", from: "Are you a high schooler?"

    fill_in "Name of the hackathon", with: "Assemble"
    fill_in "Start date", with: 1.month.from_now.beginning_of_minute
    fill_in "End date", with: (1.month.from_now + 2.days).beginning_of_minute
    fill_in "Website", with: "https://assemble.hackclub.com"

    attach_file "Logo", Rails.root.join("test/fixtures/files/assemble_logo.jpg")
    attach_file "Banner", Rails.root.join("test/fixtures/files/assemble.jpg")

    select "In Person", from: "Where is the hackathon taking place?"
    fill_in "Street", with: "760 Market St"
    fill_in "City", with: "San Francisco"
    fill_in "State/Province", with: "CA"
    fill_in "ZIP/Postal Code", with: "94102"
    select "United States", from: "Country"

    fill_in :hackathon_expected_attendees, with: 100

    select "Yes", from: :hackathon_offers_financial_assistance
    select "Yes", from: :requested_swag

    fill_in "Street", with: "760 Market St", id: :hackathon_swag_mailing_address_attributes_line1
    fill_in "City", with: "San Francisco", id: :hackathon_swag_mailing_address_attributes_city
    fill_in "State/Province", with: "CA", id: :hackathon_swag_mailing_address_attributes_province
    # country dropdown is on US by default

    assert_difference -> { Hackathon.count } do
      click_on "Submit for Review"
      assert_text(/submitted/i)
    end

    assert Hackathon.last.requested_swag?
  end
end
