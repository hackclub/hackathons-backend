require "test_helper"

class DatabaseDumpTest < ActiveSupport::TestCase
  test "dumping" do
    dump = DatabaseDump.new
    dump.process

    assert dump.processed?
    assert dump.file.attached?
  end
end
