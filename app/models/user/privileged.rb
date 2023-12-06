module User::Privileged
  extend ActiveSupport::Concern

  included do
    scope :admins, -> { where admin: true }

    after_save :record_privilege_changes, if: :saved_change_to_admin?
  end

  private

  def record_privilege_changes
    if admin?
      record :promoted_to_admin
    else
      record :demoted_from_admin
    end
  end
end
