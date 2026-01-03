class Hackathons::DigestsDeliveryJob < ApplicationJob
  def perform
    sent_digest_ids = []
    current_subscribers.find_each do |subscriber|
      next unless new_digest_pertinent?(subscriber)

      digest = subscriber.digests.new

      digest.save! unless digest.invalid? && digest.listings.none?
      sent_digest_ids << digest.id if digest.persisted?
    end
  ensure
    Hackathons::DigestMailer.admin_summary(sent_digest_ids).deliver_later if sent_digest_ids.any?
  end

  private

  def current_subscribers
    User.includes(:subscriptions).where(subscriptions: {status: :active}).includes(:digests)
  end

  def new_digest_pertinent?(subscriber)
    subscriber.digests.none? { it.created_at.after?(6.days.ago) }
  end
end
