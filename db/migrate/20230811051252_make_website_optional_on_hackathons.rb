class MakeWebsiteOptionalOnHackathons < ActiveRecord::Migration[7.0]
  def change
    change_column_null :hackathons, :website, true
  end
end
