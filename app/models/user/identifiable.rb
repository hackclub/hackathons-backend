module User::Identifiable
  extend ActiveSupport::Concern

  included do
    validates :email_address, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
    encrypts :email_address, downcase: true, deterministic: true
  end
end
