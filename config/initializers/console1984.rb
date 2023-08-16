Rails.application.configure do
  config.console1984.ask_for_username_if_empty = true
  config.console1984.incinerate = false
  config.console1984.production_data_warning = <<~WARNING
    You have access to production data here. That's a big deal.
    To keep sensitive info safe and private, we audit the commands you type here.
  WARNING
end
