class ApplicationController < ActionController::Base
  include Audit1984

  include SetCurrentRequestDetails
  include Authenticate
  include StreamFlashes
end
