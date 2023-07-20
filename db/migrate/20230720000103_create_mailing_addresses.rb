class CreateMailingAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :mailing_addresses do |t|
      t.string :name
      t.string :line1, null: false
      t.string :line2
      t.string :city, null: false
      t.string :province
      t.string :postal_code
      t.string :country_code, null: false, default: "US"

      t.timestamps
    end

    add_reference :hackathons, :swag_mailing_address, foreign_key: {to_table: :mailing_addresses}
  end
end
