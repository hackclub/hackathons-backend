module Hackathon::Notifying
  extend ActiveSupport::Concern

  included do
    after_create_commit :notify_admins, on: :submit
  end

  private

  def notify_admins
    HackathonMailer.with(hackathon: self).submission.deliver_later
  end
end
