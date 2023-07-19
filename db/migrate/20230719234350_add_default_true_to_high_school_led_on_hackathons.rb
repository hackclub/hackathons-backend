class AddDefaultTrueToHighSchoolLedOnHackathons < ActiveRecord::Migration[7.0]
  def change
    change_column_default :hackathons, :high_school_led, from: nil, to: true
  end
end
