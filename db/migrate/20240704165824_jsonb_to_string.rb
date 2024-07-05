class JsonbToString < ActiveRecord::Migration[8.0]
  def change
    change_column :events, :details, :string
    change_column :users, :settings, :string
  end
end
