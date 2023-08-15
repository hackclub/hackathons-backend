class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Audits1984

  include SetCurrentRequestDetails
  include Authenticate
end
