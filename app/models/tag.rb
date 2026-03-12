class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :taggings, dependent: :destroy

  after_update :touch_taggables, if: :saved_changes?

  private

  def touch_taggables
    taggings.in_batches do |taggings|
      taggable_ids_by_type_in(taggings).each do |taggable_type, ids|
        taggable_type.safe_constantize&.where(id: ids)&.touch_all
      end
    end
  end

  def taggable_ids_by_type_in(taggings)
    taggings.pluck(:taggable_type, :taggable_id)
      .group_by(&:shift).transform_values!(&:flatten)
  end
end
