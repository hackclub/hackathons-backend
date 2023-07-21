module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

  def tag_with(tags = nil, name: nil)
    if (tag = Tag.find_by(name: name))
      taggings.create_or_find_by! tag: tag
    end
    if tags
      Array(tags).each do |tag|
        taggings.create_or_find_by! tag: tag
      end
    end
  end

  def tag_with!(tags = nil, name: nil)
    if name
      tag = Tag.find_or_create_by! name: name
      tag_with tag
    end
    if tags
      tag_with tags
    end
  end

  def untag(tags = nil, name: nil)
    if name
      taggings.destroy_by tag: Tag.find_by(name: name)
    end
    if tags
      taggings.destroy_by tag: Array(tags)
    end
  end
end
