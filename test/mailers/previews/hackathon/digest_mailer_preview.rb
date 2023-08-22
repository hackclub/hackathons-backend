# Preview all emails at http://localhost:3000/rails/mailers/hackathons/digest_mailer
class Hackathons::DigestMailerPreview < ActionMailer::Preview
  def digest
    Hackathons::DigestMailer.with(digest: Hackathon::Digest.last).digest
  end

  def admin_summary
    Hackathons::DigestMailer.admin_summary(Hackathon::Digest.all)
  end
end
