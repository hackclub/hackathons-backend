module DatabaseDump::Processed
  extend ActiveSupport::Concern

  included do
    has_one_attached :file

    after_create_commit :process_later
  end

  def processed?
    file.attached?
  end

  def process
    return if processed?

    raise "sqlite3 not found" unless `which sqlite3`.present?

    transaction do
      Tempfile.create do |io|
        dump DatabaseDump::TABLES, to: io.path

        file.attach io:, filename: "#{name.delete(",").tr(" ", "-")}.sql"
        record :processed
      end
    end
  end

  private

  def process_later
    DatabaseDumpJob.perform_later(self)
  end

  def dump(tables, to:)
    db = self.class.connection.raw_connection.filename
    system "sqlite3 #{db} \".dump '#{tables.join("' '")}'\" > #{to}", exception: true
  end
end
