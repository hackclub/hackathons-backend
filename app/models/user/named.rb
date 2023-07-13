module User::Named
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true
    encrypts :name
  end
end
