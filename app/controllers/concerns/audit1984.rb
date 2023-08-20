module Audit1984
  private

  def find_current_auditor
    Current.user if Current.user&.admin?
  end
end
