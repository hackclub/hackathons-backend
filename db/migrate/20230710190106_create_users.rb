class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email_address, null: false, index: {unique: true}
      t.string :name
      t.boolean :admin, default: false, null: false, index: true

      t.timestamps
    end
  end
end
