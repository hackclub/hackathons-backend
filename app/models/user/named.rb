module User::Named
  extend ActiveSupport::Concern

  included do
    encrypts :name
  end

  def first_name
    name&.split(" ")&.first
  end
end
