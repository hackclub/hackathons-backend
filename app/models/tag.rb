class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :taggings, dependent: :destroy
  has_many :taggables, through: :taggings

  after_update :touch_taggings, if: :saved_changes?

  private

  def touch_taggings
    taggings.in_batches.touch_all
  end
end
