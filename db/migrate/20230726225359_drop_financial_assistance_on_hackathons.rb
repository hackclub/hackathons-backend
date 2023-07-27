class DropFinancialAssistanceOnHackathons < ActiveRecord::Migration[7.0]
  def change
    remove_column :hackathons, :financial_assistance
  end
end
