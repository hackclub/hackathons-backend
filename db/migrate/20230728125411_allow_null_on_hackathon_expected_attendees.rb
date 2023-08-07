class AllowNullOnHackathonExpectedAttendees < ActiveRecord::Migration[7.0]
  def change
    change_column_null :hackathons, :expected_attendees, true
  end
end
