class CreateHackathonSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :hackathon_subscriptions do |t|
      t.belongs_to :subscriber, null: false, foreign_key: {to_table: :users}

      t.integer :status, default: 1, null: false

      t.index [:status, :subscriber_id]

      t.string :country_code
      t.string :province
      t.string :city
      t.string :postal_code, index: true

      t.index [:country_code, :province, :city], name: :index_hackathon_subscriptions_on_country_and_province_and_city
      t.index [:country_code, :city]

      t.float :latitude
      t.float :longitude

      t.index [:latitude, :longitude]

      t.timestamps
    end
  end
end
