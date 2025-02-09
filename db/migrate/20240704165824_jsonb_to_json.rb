class JsonbToJson < ActiveRecord::Migration[8.0]
  def change
    change_column :events, :details, :json
    change_column :users, :settings, :json
  end
end
