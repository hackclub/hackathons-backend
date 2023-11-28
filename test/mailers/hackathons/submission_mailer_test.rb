require "test_helper"

class Hackathons::SubmissionMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @hackathon = hackathons(:zephyr)
  end

  test "confirmation" do
    email = Hackathons::SubmissionMailer.with(hackathon: @hackathon).confirmation.deliver_now

    assert email.to, @hackathon.applicant.email_address

    assert_includes email.subject, "submitted"
  end

  test "admin notification" do
    email = Hackathons::SubmissionMailer.with(hackathon: @hackathon).admin_notification.deliver_now

    assert email.to, User.admins.pluck(:email_address)

    assert_includes email.subject, "submitted"
    assert_includes email.subject, @hackathon.name

    assert_includes email.to_s, admin_hackathon_url(@hackathon)
  end

  test "approval" do
    email = Hackathons::SubmissionMailer.with(hackathon: @hackathon).approval.deliver_now

    assert email.to, @hackathon.applicant.email_address

    assert_includes email.subject, "approved"
  end
end
