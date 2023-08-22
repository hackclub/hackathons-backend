class Hackathons::SendDigestsJob < ApplicationJob
  sidekiq_options retry: 20 # up to 6.5 days

  def perform
    sent_digests = []
    current_subscribers.find_each do |subscriber|
      next unless new_digest_pertinent?(subscriber)

      digest = subscriber.digests.new

      digest.save! unless digest.invalid? && digest.listings.none?
      sent_digests << digest if digest.persisted?
    end
  ensure
    Hackathons::DigestMailer.admin_summary(sent_digests).deliver_later if sent_digests.any?
  end

  private

  def current_subscribers
    User.includes(:subscriptions).where(subscriptions: {status: :active})
  end

  def new_digest_pertinent?(subscriber)
    subscriber.digests.none? || subscriber.digests.last.created_at.before?(6.days.ago)
  end
end
