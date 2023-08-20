module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings

    scope :tagged_with, ->(tags_or_names) {
      tags, names = Array(tags_or_names).partition { |tag| tag.is_a? Tag }
      tags.concat Tag.where(name: names)

      joins(:taggings).where(taggings: {tag: tags})
    }
  end

  def tagged_with?(tags_or_names)
    return false unless tags_or_names.present?
    Array(tags_or_names).all? do |tag|
      if tags.loaded?
        # Use loaded association to prevent N+1
        tags.any? do |t|
          next t == tag if t.is_a? Tag
          t.name == tag # tag is a name (string)
        end
      elsif tag.is_a? Tag
        tags.include? tag
      else
        tags.exists? name: tag
      end
    end
  end

  def tag_with(tags_or_names)
    Array(tags_or_names).each do |tag|
      tag = Tag.find_by(name: tag) unless tag.is_a? Tag
      if new_record?
        taggings.find_or_initialize_by tag: tag
      else
        taggings.find_or_create_by tag: tag
      end
    end
  end

  def tag_with!(tags_or_names)
    tags = Array(tags_or_names).map do |tag|
      next tag if tag.is_a? Tag
      Tag.find_or_initialize_by(name: tag)
    end

    tag_with tags
  end

  def untag(tags_or_names)
    Array(tags_or_names).each do |tag|
      tag = Tag.find_by name: tag unless tag.is_a? Tag
      taggings.destroy_by tag: tag
    end
  end
end
