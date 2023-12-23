class AddSettingsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :settings, :jsonb, default: {}, null: false
  end
end
