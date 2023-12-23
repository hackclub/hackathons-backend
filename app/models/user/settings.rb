User::SETTINGS = [
  :new_submission_notifications
]

User::DEFAULT_SETTINGS = {
  new_submission_notifications: true
}

module User::Settings
  extend ActiveSupport::Concern

  included do
    scope :with_setting_not_disabled, ->(setting) { where("settings ->> ? != 'false'", setting.to_s) }
  end

  User::SETTINGS.each do |setting|
    define_method setting do
      settings[setting.to_s] || User::DEFAULT_SETTINGS[setting]
    end

    define_method :"#{setting}=" do |value|
      settings[setting.to_s] = value
    end
  end
end
