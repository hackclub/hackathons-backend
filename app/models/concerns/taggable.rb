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
    Array(tags_or_names).each do |tag|
      tag = Tag.find_by(name: tag) unless tag.is_a? Tag
      taggings.create_or_find_by tag: tag
    end
  end

  def tag_with!(tags_or_names)
    Array(tags_or_names).each do |tag|
      tag = Tag.find_or_initialize_by(name: tag) unless tag.is_a? Tag
      taggings.create_or_find_by tag: tag
    end
  end

  def untag(tags_or_names)
    Array(tags_or_names).each do |tag|
      tag = Tag.find_by name: tag unless tag.is_a? Tag
      taggings.destroy_by tag: tag
    end
  end
end
