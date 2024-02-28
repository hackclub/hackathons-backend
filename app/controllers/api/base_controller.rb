class Api::BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token # CSRF

  include Api::Errors

  before_action :set_request_version

  private

  def set_request_version
    @request_version = request_version
  end
end
