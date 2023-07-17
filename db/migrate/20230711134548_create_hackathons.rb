class CreateHackathons < ActiveRecord::Migration[7.0]
  def change
    create_table :hackathons do |t|
      t.string :name, null: false

      t.integer :status, default: 0, null: false

      t.datetime :starts_at
      t.datetime :ends_at

      t.index [:status, :starts_at, :ends_at]

      t.string :country_code
      t.string :province
      t.string :city
      t.string :postal_code, index: true
      t.string :address, index: true

      t.index [:country_code, :province, :city]
      t.index [:country_code, :city]

      t.float :latitude
      t.float :longitude

      t.index [:latitude, :longitude]
    end
  end
end
