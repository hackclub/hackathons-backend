class AddFieldsToHackathons < ActiveRecord::Migration[7.0]
  def change
    add_column :hackathons, :website, :string, null: false
    add_column :hackathons, :high_school_led, :boolean, null: false
    add_column :hackathons, :expected_attendees, :integer, null: false
    add_column :hackathons, :modality, :integer, null: false, default: 0
    add_column :hackathons, :financial_assistance, :boolean, null: false
  end
end
