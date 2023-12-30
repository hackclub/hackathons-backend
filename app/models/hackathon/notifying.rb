module Hackathon::Notifying
  extend ActiveSupport::Concern

  included do
    after_create_commit :deliver_confirmation, :notify_admins, on: :submit
    after_update_commit :deliver_approval, if: -> { saved_change_to_status? && approved? }
  end

  private

  def deliver_confirmation
    Hackathons::SubmissionMailer.with(hackathon: self).confirmation.deliver_later
  end

  def notify_admins
    Hackathons::SubmissionMailer.with(hackathon: self).admin_notification.deliver_later
  end

  def deliver_approval
    Hackathons::SubmissionMailer.with(hackathon: self).approval.deliver_later
  end
end
