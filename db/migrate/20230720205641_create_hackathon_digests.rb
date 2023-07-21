class CreateHackathonDigests < ActiveRecord::Migration[7.0]
  def change
    create_table :hackathon_digests do |t|
      t.belongs_to :recipient, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end

    create_table :hackathon_digest_listings do |t|
      t.belongs_to :digest, null: false, foreign_key: {to_table: :hackathon_digests}
      t.references :hackathon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
