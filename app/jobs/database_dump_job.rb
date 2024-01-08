class DatabaseDumpJob < ApplicationJob
  queue_as :low

  def perform(database_dump)
    database_dump.process
  end
end
