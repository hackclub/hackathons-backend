# Preview all emails at http://localhost:3000/rails/mailers/hackathons/digest_mailer
class Hackathons::DigestMailerPreview < ActionMailer::Preview
  def digest
    Hackathons::DigestMailer.digest(Hackathon::Digest.last)
  end

  def admin_summary
    Hackathons::DigestMailer.admin_summary(Hackathon::Digest.all)
  end
end
