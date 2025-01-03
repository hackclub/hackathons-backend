class CreateLocks < ActiveRecord::Migration[8.1]
  def change
    create_table :locks do |t|
      t.string :key, null: false, index: {unique: true}
      t.integer :capacity, null: false, default: 0
      t.datetime :expiration, index: true

      t.timestamps
    end
  end
end
