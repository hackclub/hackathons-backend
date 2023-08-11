# Preview all emails at http://localhost:3000/rails/mailers/hackathons/digest_mailer
class Hackathons::DigestMailerPreview < ActionMailer::Preview
  def digest
    Hackathons::DigestMailer.with(digest: Hackathon::Digest.last).digest
  end

  def admin_summary
    Hackathons::DigestMailer.with(digests: Hackathon::Digest.all).admin_summary
  end
end
