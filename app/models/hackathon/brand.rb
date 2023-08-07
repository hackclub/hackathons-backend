module Hackathon::Brand
  extend ActiveSupport::Concern

  included do
    validates :website, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), on: :submit

    has_one_attached :logo do |logo|
      logo.variant :small, resize_to_limit: [128, 128]
    end
    has_one_attached :banner do |banner|
      banner.variant :large, resize_to_limit: [1920, 1080]
    end

    validates :logo, :banner,
      attached: true, content_type: {in: /\Aimage\/.*\z/, message: "is not an image"},
      size: {less_than: 25.megabytes, message: "is too powerful (max 25 MB)"},
      on: :submit

    validates :banner, aspect_ratio: :landscape
  end
end
