# Preview all emails at http://localhost:3000/rails/mailers/hackathon/digest_mailer
class Hackathons::DigestMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/hackathon/digest_mailer/by_location
  def by_location
    Hackathons::DigestMailer.with(digest: Hackathon::Digest.last).digest
  end
end
