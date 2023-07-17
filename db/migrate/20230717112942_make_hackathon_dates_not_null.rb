class MakeHackathonDatesNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :hackathons, :starts_at, false
    change_column_null :hackathons, :ends_at, false
  end
end
