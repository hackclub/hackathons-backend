class AddBelongsToSubscriptionOnHackathonDigestLisings < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :hackathon_digest_listings, :subscription, null: false, foreign_key: {to_table: :hackathon_subscriptions}
  end
end
