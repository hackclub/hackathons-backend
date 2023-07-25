class Api::NotFoundError < Api::Error
  def initialize(
    title: "Not Found",
    detail: "The resource you requested could not be found.",
    status: :not_found,
    type: :not_found_error,
    backtrace: nil
  )
    super
  end
end
