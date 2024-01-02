User::DEFAULT_SETTINGS = {
  new_hackathon_submission_notifications: true
}

User::SETTINGS = User::DEFAULT_SETTINGS.keys

module User::Settings
  extend ActiveSupport::Concern

  included do
    scope :with_setting_not_disabled, ->(setting) { where("settings ->> ? IS NULL OR settings ->> ? != 'false'", setting.to_s, setting.to_s) }
  end

  User::SETTINGS.each do |setting|
    define_method setting do
      if settings[setting.to_s].nil?
        User::DEFAULT_SETTINGS[setting]
      else
        settings[setting.to_s]
      end
    end

    define_method :"#{setting}=" do |value|
      settings[setting.to_s] = value
    end
  end
end
