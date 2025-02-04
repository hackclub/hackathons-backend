class RemoveUniqueConstraintOnLocks < ActiveRecord::Migration[8.1]
  def change
    remove_index :locks, :key, unique: true
    add_index :locks, :key, unique: false
  end
end
