class AddApplicantToHackathons < ActiveRecord::Migration[7.0]
  def change
    add_reference :hackathons, :applicant, null: false, foreign_key: {to_table: :users}
  end
end
