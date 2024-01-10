class CreateDatabaseDumps < ActiveRecord::Migration[7.2]
  def change
    create_table :database_dumps do |t|
      t.string :name

      t.timestamps
    end
  end
end
