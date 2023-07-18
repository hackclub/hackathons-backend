class CreateEventRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :event_requests do |t|
      t.references :event, null: false, foreign_key: true

      t.string :uuid
      t.string :user_agent
      t.string :ip_address

      t.timestamps
    end
  end
end
