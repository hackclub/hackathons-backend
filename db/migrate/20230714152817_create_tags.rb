class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false, index: true
      t.string :color_hex

      t.timestamps
    end

    create_table :taggings do |t|
      t.belongs_to :taggable, polymorphic: true, null: false, index: false
      t.belongs_to :tag, null: false

      t.index [:taggable_type, :taggable_id, :tag_id], unique: true

      t.timestamps
    end
  end
end
