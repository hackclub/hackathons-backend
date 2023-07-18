module User::Named
  extend ActiveSupport::Concern

  included do
    encrypts :name
  end
end
