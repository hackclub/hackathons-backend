class AddAirtableIdToHackathonSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :hackathon_subscriptions, :airtable_id, :string
    add_index :hackathon_subscriptions, :airtable_id, unique: true
  end
end
