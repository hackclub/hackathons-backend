module Api::Errors
  extend ActiveSupport::Concern

  included do
    # Since these handlers are called from bottom to top, the catch-all handler
    # needs to be at the top. More specific handlers should belong at the bottom.
    rescue_from StandardError, with: :server_error

    # Handle any custom API errors. Generally when creating and raising these
    # errors, we add additional context such as the `title` and `detail` as a
    # part of instantiating the error.
    rescue_from Api::Error, with: :api_error

    # Handle any non-custom API errors. These require a custom handler to add
    # more context such as the `title` and `detail`.
    rescue_from VersionCake::UnsupportedVersionError, with: :unsupported_version
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
    rescue_from ActionController::ParameterMissing, with: :bad_request
  end

  private

  def unsupported_version(error)
    api_version = params[:api_version]
    detail = "API version #{api_version} is not supported."

    api_error ::Api::InvalidApiVersionError.new(detail:, backtrace: error.backtrace)
  end

  def not_found(error)
    model_name = error.try(:model) || "object"
    id = error.try(:id) || params[:id]

    detail = "The #{model_name}"
    detail += " with id '#{id}'" if id
    detail += " could not be found."

    api_error ::Api::NotFoundError.new(detail:, backtrace: error.backtrace)
  end

  def invalid_record(error)
    api_error ::Api::BadRequestError.new(
      detail: error.record&.errors&.full_messages&.join(", "),
      backtrace: error.backtrace
    )
  end

  def bad_request(error)
    api_error ::Api::BadRequestError.new(
      detail: error.message,
      backtrace: error.backtrace
    )
  end

  def server_error(error)
    Rails.logger.error(error.inspect)
    raise error if Rails.env.development?

    render_error error, type: :internal_server_error, status: :internal_server_error,
      title: "An error has occurred",
      detail: "Please try again later. If the problem persists, please contact #{Hackathons::SUPPORT_EMAIL}."
  end

  def api_error(error)
    render_error error,
      type: error.type,
      status: error.status,
      title: error.title,
      detail: error.detail
  end

  # This is the method that actually renders the error. It sets up the instance
  # variables and renders the partial.
  def render_error(error, type:, status: nil, title: nil, detail: nil)
    @error = error

    @title = title || error.message || "An error has occurred."
    @detail = detail || "An error has occurred."
    @type = type || :error

    @status_code = status.then do |s|
      next s if s&.is_a?(Integer)
      # Converts :not_found to 404, and falls back to 400 if unknown or nil
      Rack::Utils::SYMBOL_TO_STATUS_CODE[s&.to_sym] || 400
    end

    render partial: "api/errors/error", status: @status_code
  end
end
