module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

  def tag_with(tags_or_names)
    Array(tags_or_names).each do |tag_or_name|
      if tag_or_name.is_a? Tag
        taggings.create_or_find_by! tag: tag_or_name
      else
        tag = Tag.find_by name: tag_or_name
        taggings.create_or_find_by!(tag:) if tag
      end
    end
  end

  def tag_with!(tags_or_names)
    Array(tags_or_names).each do |tag_or_name|
      if tag_or_name.is_a? Tag
        tag_with tag_or_name
      else
        tag_with Tag.find_or_create_by!(name: tag_or_name)
      end
    end
  end

  def untag(tags_or_names)
    Array(tags_or_names).each do |tag_or_name|
      if tag_or_name.is_a? Tag
        taggings.destroy_by tag: tag_or_name
      else
        tag = Tag.find_by name: tag_or_name
        taggings.destroy_by tag: tag
      end
    end
  end
end
