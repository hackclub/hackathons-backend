class AddApacToHackathon < ActiveRecord::Migration[7.0]
  def change
    add_column :hackathons, :apac, :boolean
  end
end
