class CreateSwagRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :hackathon_swag_requests do |t|
      t.references :hackathon, null: false, foreign_key: true
      t.references :mailing_address, null: false, foreign_key: true

      t.timestamp :delivered_at

      t.timestamps
    end

    Hackathon.where.associated(:swag_mailing_address).includes(:swag_mailing_address).find_each do |hackathon|
      Hackathon::SwagRequest::Delivered.suppress do
        hackathon.create_swag_request!(mailing_address: hackathon.swag_mailing_address.attributes)
      end
    end
  end
end
