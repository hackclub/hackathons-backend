require "test_helper"

class Hackathon::DigestMailerTest < ActionMailer::TestCase
  test "digest" do
    digest = hackathon_digests(:one)
    mail = Hackathon::DigestMailer.with(digest:).digest

    assert_equal "Hackathons near you", mail.subject
    assert_equal [digest.recipient.email_address], mail.to

    digest.listings.map(&:subscription).each do |subscription|
      assert_match "Near #{subscription.to_location.to_fs(:short)}", mail.body.encoded
    end

    digest.listings.map(&:hackathon).each do |hackathon|
      assert_match hackathon.name, mail.body.encoded
    end

    assert_match "unsubscribe", mail.body.encoded
  end
end
