# Preview all emails at http://localhost:3000/rails/mailers/hackathon/digest_mailer
class Hackathon::DigestMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/hackathon/digest_mailer/by_location
  def by_location
    Hackathon::DigestMailer.with(digest: Hackathon::Digest.last).by_location
  end
end
