class ApplicationController < ActionController::Base
  include Pagy::Backend

  include SetCurrentRequestDetails
  include Authenticate
end
