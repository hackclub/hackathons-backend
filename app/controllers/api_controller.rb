class ApiController < ActionController::Base
  # Don't check CSRF token for API routes
  skip_before_action :verify_authenticity_token

  # Pagination
  include Pagy::Backend
  helper_method :pagy_metadata
  after_action { pagy_headers_merge(@pagy) if @pagy }

  include Api::Concerns::Errors

  before_action :set_request_version

  private

  def set_request_version
    @request_version = request_version
  end
end
