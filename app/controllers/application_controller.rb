class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authenticate
end
