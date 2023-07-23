module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings

    # scope that handles tags or names of tags passed in
    scope :tagged_with_old, ->(tags_or_names) {
      Array(tags_or_names).flat_map do |tag|
        tag = Tag.find_by(name: tag) unless tag.is_a? Tag
        joins(:taggings).where(taggings: {tag: tag})
      end
    }

    scope :tagged_with, ->(tags_or_names) {
      tags, names = Array(tags_or_names).partition { |tag| tag.is_a? Tag }
      tags.concat Tag.where(name: names)

      joins(:taggings).where(taggings: {tag: tags})
    }
  end

  def tagged_with?(tags_or_names)
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
