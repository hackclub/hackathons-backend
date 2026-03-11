class RenameLocksToRateLimitWindows < ActiveRecord::Migration[8.2]
  def change
    rename_table :locks, :rate_limit_windows
    rename_column :rate_limit_windows, :capacity, :tally

    reversible do |dir|
      dir.up do
        # Ensure there are no duplicate keys before adding a unique index.
        # Keeps the lowest-id row for each key and deletes the rest.
        execute <<~SQL.squish
          DELETE FROM rate_limit_windows a
          USING rate_limit_windows b
          WHERE a.id < b.id
            AND a.key = b.key;
        SQL
      end
    end
    remove_index :rate_limit_windows, :key
    add_index :rate_limit_windows, :key, unique: true
  end
end
