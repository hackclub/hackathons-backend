module Hackathon::Branded
  extend ActiveSupport::Concern

  included do
    has_one_attached :logo, analyze: :immediately do |logo|
      logo.variant :small, resize_to_limit: [128, 128]
    end

    has_one_attached :banner, analyze: :immediately do |banner|
      banner.variant :small, resize_to_limit: [228, 128]
      banner.variant :large, resize_to_limit: [1920, 1080]
    end

    validates :logo, :banner, processable_file: true,
      content_type: {in: ActiveStorage.variable_content_types, message: "must be a valid image format (png, jpeg, webp, etc.)"}

    validates :logo, :banner, on: :submit, attached: true,
      size: {less_than: 25.megabytes, message: "is too powerful (max 25 MB)"}
  end
end
