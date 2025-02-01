module Hackathon::Branded
  extend ActiveSupport::Concern

  included do
    has_one_attached :logo do |logo|
      logo.variant :small, resize_to_limit: [128, 128]
    end
    has_one_attached :banner do |banner|
      banner.variant :small, resize_to_limit: [228, 128]
      banner.variant :large, resize_to_limit: [1920, 1080]
    end

    validates :logo, :banner, processable_file: true
    validates :logo, :banner, on: :submit, attached: true,
      size: {less_than: 25.megabytes, message: "is too powerful (max 25 MB)"}

    before_validation :jfif_to_jpeg, if: -> { attachment_changes.any? }, on: :create
  end

  private

  def jfif_to_jpeg
    logo&.blob&.filename = logo&.blob&.filename&.to_s&.gsub(/\.jfif\z/i, ".jpeg")
    banner&.blob&.filename = banner&.blob&.filename&.to_s&.gsub(/\.jfif\z/i, ".jpeg")
  end
end
