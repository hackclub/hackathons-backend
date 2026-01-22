module StringLiteralMutationReporting
  class Warning < StandardError; end

  FROZEN_STRING_PATTERN = /warning: literal string will be frozen in the future/

  def warn(message, category: nil)
    if message.match?(FROZEN_STRING_PATTERN)
      Rails.error.report(
        StringLiteralMutationReporting::Warning.new(message.strip),
        handled: true,
        severity: :warning,
        context: {category:}
      )
    end
  ensure
    super
  end
end

Warning.extend(StringLiteralMutationReporting)
