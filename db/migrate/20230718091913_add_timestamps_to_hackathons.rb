class AddTimestampsToHackathons < ActiveRecord::Migration[7.0]
  def change
    # If you have existing Hackathons in your database, this migration will fail
    # due to the NOT NULL constraint on `created_at` and `updated_at`.
    #
    # Since we currently don't have any production data, this migration is safe
    # as is. To fix this failed migration, destroy all Hackathon records by
    # running the following in the Rails console:
    #   Hackathon.destroy_all
    # Then, re-run this migration:
    #   rails db:migrate

    add_timestamps :hackathons
  end
end
