class AddStreetToHackathons < ActiveRecord::Migration[7.0]
  def change
    add_column :hackathons, :street, :string
  end
end
