require "test_helper"

class Hackathons::OrganizerSummaryTest < ActionMailer::TestCase
  test "organizer_summary" do
    sent_digests = [hackathon_digests(:one)]
    hackathon = sent_digests[0].listings[0].hackathon
    mail = Hackathons::DigestMailer.organizer_summary(hackathon, sent_digests)

    assert_equal "We've just notified #{sent_digests.count} hackers about #{hackathon.name}!", mail.subject
    assert_equal [hackathon.applicant.email_address], mail.to

    assert_match "We've just sent an email about #{hackathon.name} to #{sent_digests.count} hackers.", mail.body.encoded

    # Email CAN-SPAM compliance
    assert_match "unsubscribe", mail.body.encoded
    assert_match Hackathons::HACK_CLUB_ADDRESS[:full], mail.body.encoded
  end
end
