require "test_helper"

class Hackathons::SubmissionMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @hackathon = hackathons(:zephyr)
  end

  test "submission notification for admins" do
    submission = HackathonMailer.with(hackathon: @hackathon).submission
    submission_delivery = submission.deliver_now

    assert submission_delivery.to, User.admins.pluck(:email_address)

    assert_includes submission_delivery.subject, "submitted"
    assert_includes submission_delivery.subject, @hackathon.name

    assert_includes submission_delivery.to_s, admin_hackathon_url(@hackathon)
  end
end
