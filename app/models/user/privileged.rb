module User::Privileged
  def promote_to_admin
    transaction do
      update! admin: true
      record :promoted_to_admin
    end
  end

  def demote_from_admin
    transaction do
      update! admin: false
      record :demoted_from_admin
    end
  end
end
