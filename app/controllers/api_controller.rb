class ApiController < ActionController::Base
  before_action :set_request_version

  private

  def set_request_version
    @request_version = request_version
  end
end
