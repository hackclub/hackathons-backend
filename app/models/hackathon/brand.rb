module Hackathon::Brand
  extend ActiveSupport::Concern

  included do
    has_one_attached :logo do |logo|
      logo.variant :small, resize_to_limit: [128, 128]
    end
    has_one_attached :banner do |banner|
      banner.variant :large, resize_to_limit: [1920, 1080]
    end

    validates :logo, :banner,
      attached: true,
      size: {less_than: 25.megabytes, message: "is too powerful (max 25 MB)"},
      on: :submit

    validates :logo, :banner,
      content_type: {in: /\Aimage\/.*\z/, message: "is not an image"}
  end
end
