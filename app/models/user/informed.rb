module User::Informed
  extend ActiveSupport::Concern

  included do
    after_save_commit -> { LoopsSynchronizationJob.perform_later(self) }, if: :sync_with_loops?
  end

  def sync_with_loops
    if (contact = Loops::Contact.find(email_address))
      contact.subscribedToHackathonsAt = created_at
      contact.save
    else
      Loops::Contact.create(
        email: email_address,
        firstName: first_name,
        fullName: name,
        userGroup: "Hack Clubber",
        source: "hackathons.hackclub.com",
        subscribedToHackathonsAt: created_at
      )
    end
  end

  private

  def sync_with_loops?
    Rails.env.production? && saved_change_to_email_address? && subscriptions.active.present?
  end
end
