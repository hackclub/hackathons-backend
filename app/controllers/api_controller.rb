class ApiController < ActionController::Base
  include Api::Concerns::Errors

  before_action :set_request_version

  private

  def set_request_version
    @request_version = request_version
  end
end
