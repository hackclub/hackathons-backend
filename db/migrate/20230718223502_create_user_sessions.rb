class CreateUserSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_authentications do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.string :token, null: false, index: true

      t.timestamps
    end

    create_table :user_sessions do |t|
      t.references :authentication, null: false, foreign_key: {to_table: :user_authentications}

      t.string :token, null: false, index: true

      t.timestamp :last_accessed_at

      t.timestamps
    end
  end
end
