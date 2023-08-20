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
      tag = Tag.find_by(name: tag) unless tag.is_a? Tag
      tags.include? tag
    end
  end

  def tag_with(tags_or_names)
    new_taggings = Array(tags_or_names).map do |tag|
      tag = Tag.find_by(name: tag) unless tag.is_a? Tag
      next unless tag

      if new_record?
        taggings.find_or_initialize_by tag: tag
      else
        taggings.find_or_create_by tag: tag
      end
    end

    return false if new_taggings.include? nil # At least one tag didn't exist
    new_taggings
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
