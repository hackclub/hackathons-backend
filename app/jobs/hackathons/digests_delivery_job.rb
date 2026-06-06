class Hackathons::DigestsDeliveryJob < ApplicationJob
  def perform
    sent_digest_ids = []
    current_subscribers_due_for_digest.find_each(batch_size: 500) do |subscriber|
      digest = subscriber.digests.new

      digest.save! unless digest.invalid? && digest.listings.none?
      sent_digest_ids << digest.id if digest.persisted?
    end
  ensure
    Hackathons::DigestMailer.admin_summary(sent_digest_ids).deliver_later if sent_digest_ids.any?
  end

  private

  def current_subscribers_due_for_digest
    User.includes(:active_subscriptions).where.associated(:active_subscriptions)
      .where.missing :digests_in_past_week
  end
end
