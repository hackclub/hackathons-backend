class ApiController < ActionController::Base
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
