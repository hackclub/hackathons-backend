module Api::Concerns::Errors
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
  end

  private

  def unsupported_version(error)
    api_version = params[:api_version]

    render_error error, type: :invalid_api_version_error,
      title: "Unsupported API version",
      detail: "API version v#{api_version} is not supported."
  end

  def not_found(error)
    model_name = error.try(:model) || "resource"
    id = error.try(:id) || params[:id]

    detail = "The requested #{model_name}"
    detail += " with id='#{id}'" if id
    detail += " could not be found."

    render_error error, type: :not_found_error, status: :not_found,
      title: "Object not found",
      detail:
  end

  def server_error(error)
    Rails.logger.error(error.inspect)
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
