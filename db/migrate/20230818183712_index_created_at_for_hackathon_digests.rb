class IndexCreatedAtForHackathonDigests < ActiveRecord::Migration[7.1]
  def change
    add_index :hackathon_digests, :created_at
  end
end
