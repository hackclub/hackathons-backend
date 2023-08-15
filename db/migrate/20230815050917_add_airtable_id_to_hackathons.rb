class AddAirtableIdToHackathons < ActiveRecord::Migration[7.1]
  def change
    add_column :hackathons, :airtable_id, :string
    add_index :hackathons, :airtable_id, unique: true
  end
end
