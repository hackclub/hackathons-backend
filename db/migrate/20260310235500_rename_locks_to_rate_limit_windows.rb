class RenameLocksToRateLimitWindows < ActiveRecord::Migration[8.2]
  def change
    rename_table :locks, :rate_limit_windows
    rename_column :rate_limit_windows, :capacity, :tally

    remove_index :rate_limit_windows, :key
    add_index :rate_limit_windows, :key, unique: true
  end
end
