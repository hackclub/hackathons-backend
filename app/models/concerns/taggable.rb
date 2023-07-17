module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

  def tag_as(name)
    if (tag = Tag.find_by(name: name))
      tag_with tag
    end
  end

  def tag_as!(name)
    tag = Tag.find_or_create_by! name: name
    tag_with tag
  end

  def tag_with(tags)
    Array(tags).each do |tag|
      taggings.create_or_find_by! tag:
    end
  end

  def untag_as(name)
    if (tag = Tag.find_by(name:))
      untag tag
    end
  end

  def untag(tags)
    Array(tags).each do |tag|
      taggings.destroy_by tag:
    end
  end
end
