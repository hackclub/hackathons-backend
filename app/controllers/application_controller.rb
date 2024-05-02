class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Audit1984

  include SetCurrentRequestDetails
  include Authenticate
  include StreamFlashes
end
