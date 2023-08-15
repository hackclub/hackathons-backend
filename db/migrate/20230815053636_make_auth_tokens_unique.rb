class MakeAuthTokensUnique < ActiveRecord::Migration[7.0]
  def change
    remove_index :user_authentications, :token
    add_index :user_authentications, :token, unique: true
    remove_index :user_sessions, :token
    add_index :user_sessions, :token, unique: true
  end
end
