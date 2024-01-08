module DatabaseDump::Processed
  extend ActiveSupport::Concern

  included do
    has_one_attached :file

    after_create_commit :process_later
  end

  def process_later
    DatabaseDumpJob.perform_later(self)
  end

  def processed?
    file.attached?
  end

  def process
    return if processed?

    raise "pg_dump not found" unless system "which pg_dump > /dev/null"

    Tempfile.create do |file|
      dump DatabaseDump::TABLES, to: file.path

      transaction do
        self.file.attach io: file, filename: "#{name.delete(",").tr(" ", "-")}.sql"
        record :processed
      end
    end
  end

  private

  def dump(tables, to:)
    set_postgres_env_vars
    system "pg_dump --table '#{tables.join("|")}' --file #{to}", exception: true
  end

  def set_postgres_env_vars
    connection = ApplicationRecord.connection_db_config.configuration_hash

    ENV["PGHOST"] = connection[:host]
    ENV["PGPORT"] = connection[:port].to_s
    ENV["PGUSER"] = connection[:username]
    ENV["PGPASSWORD"] = connection[:password]
    ENV["PGDATABASE"] = connection[:database]
  end
end
