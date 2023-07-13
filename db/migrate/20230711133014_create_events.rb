class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.belongs_to :eventable, polymorphic: true

      t.references :creator, foreign_key: {to_table: :users}
      t.references :target, foreign_key: {to_table: :users}

      t.string :action
      t.jsonb :details, default: {}, null: false

      t.timestamps
    end
  end
end
