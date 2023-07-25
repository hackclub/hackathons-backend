class Api::InvalidApiVersionError < Api::Error
  def initialize(
    title: "Unsupported API version",
    detail: "API version you requested is not supported.",
    status: :bad_request,
    type: :invalid_api_version_error,
    backtrace: nil
  )
    super
  end
end
