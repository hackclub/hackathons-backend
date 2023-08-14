class Hackathon::DigestJob
  include Sidekiq::Job
  sidekiq_options retry: 20 # up to 6.5 days

  def perform
    digests = []
    users.find_each do |user|
      # Skip if the user has a digest created in the last 6 days
      next if user.digests.last&.created_at&.after? 6.days.ago

      digest = user.digests.new

      # Save unless there are no listings to send
      digest.save! unless digest.invalid? && digest.errors.include?(:listings)
      digests << digest if digest.persisted?
    end
  ensure
    Hackathons::DigestMailer.with(digests:).admin_summary.deliver_later if digests.any?
  end

  private

  def users
    # Users with active subscriptions
    User.includes(:subscriptions).where(subscriptions: {status: :active})
  end
end
