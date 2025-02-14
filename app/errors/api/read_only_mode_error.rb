class Api::ReadOnlyModeError < Api::Error
  def initialize(
    title: "Read Only Mode",
    detail: "The app is in read only mode for maintenance. Try again in a few minutes.",
    status: :service_unavailable,
    type: :not_found_error,
    backtrace: nil
  )
    super
  end
end
