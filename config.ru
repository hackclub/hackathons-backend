# This file is used by Rack-based servers to start the application.

begin
  require_relative "config/environment"
rescue Exception => error # standard:disable Lint/RescueException
  Appsignal.send_error(error)
  raise
end

run Rails.application
Rails.application.load_server
