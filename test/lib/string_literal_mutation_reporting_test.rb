require "test_helper"

class StringLiteralMutationReportingTest < ActiveSupport::TestCase
  test "reports only mutated string literals" do
    assert_error_reported(StringLiteralMutationReporting::Warning) do
      " ".strip!
    end

    assert_no_error_reported do
      " ".dup.strip!
    end
  end
end
