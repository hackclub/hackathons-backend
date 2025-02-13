module DatabaseDump::Processed
  extend ActiveSupport::Concern

  included do
    has_one_attached :file

    after_create_commit { DatabaseDumpJob.perform_later(self) }
  end

  def processed?
    file.attached?
  end

  def process
    return if processed?

    raise "pg_dump not found" unless `which pg_dump`.present?

    transaction do
      Tempfile.create do |io|
        dump DatabaseDump::TABLES, to: io.path

        file.attach io: File.open(io), filename: "#{name.delete(",").tr(" ", "-")}.sql"
        record :processed
      end
    end
  end

  private

  def dump(tables, to:)
    system postgres_env, "pg_dump --table '#{tables.join("|")}' --file #{to}", exception: true
  end

  def postgres_env
    connection = ApplicationRecord.connection_db_config.configuration_hash

    {}.tap do |env|
      env["PGHOST"] = connection[:host]
      env["PGPORT"] = connection[:port]
      env["PGUSER"] = connection[:username]
      env["PGPASSWORD"] = connection[:password]
      env["PGDATABASE"] = connection[:database]
    end.transform_values!(&:to_s)
  end
end
