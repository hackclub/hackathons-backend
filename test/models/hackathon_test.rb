require "test_helper"
require "active_storage_validations/matchers"

class HackathonTest < ActiveSupport::TestCase
  extend ActiveStorageValidations::Matchers

  context "validations" do
    should validate_presence_of(:name)
    should validate_presence_of(:starts_at)
    should validate_presence_of(:ends_at)
    should validate_presence_of(:website)
    should validate_presence_of(:expected_attendees)

    should define_enum_for(:status)
    should define_enum_for(:modality)

    should validate_attached_of(:logo)
    should validate_attached_of(:banner)
    should validate_content_type_of(:logo)
      .allowing("image/png", "image/jpeg")
      .rejecting("text/plain", "application/pdf")
    should validate_content_type_of(:banner)
      .allowing("image/png", "image/jpeg")
      .rejecting("text/plain", "application/pdf")
  end

  test "creating a hackathon with invalid dates" do
    hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.ago,
      website: "https://hackclub.com",
      high_school_led: true,
      expected_attendees: 100,
      modality: "in_person",
      financial_assistance: true,
      logo: active_storage_blobs(:assemble_logo),
      banner: active_storage_blobs(:assemble)
      applicant: users(:gary)
    )

    assert_not hackathon.save
  end

  test "creating a hackathon" do
    hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.from_now,
      website: "https://hackclub.com",
      high_school_led: true,
      expected_attendees: 100,
      modality: "in_person",
      financial_assistance: true,
      logo: active_storage_blobs(:assemble_logo),
      banner: active_storage_blobs(:assemble)
      applicant: users(:gary)
    )

    assert hackathon.save
  end

  test "creating a hackathon without an applicant" do
    hackathon = Hackathon.new(
      name: "TestHacks",
      starts_at: Time.now,
      ends_at: 2.days.from_now
    )

    assert_not hackathon.save
  end
end
