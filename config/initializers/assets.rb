# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.assets.version = "1.0" # change to expire all assets
  config.sass.load_paths << Rails.root.join("app/assets/stylesheets")
end
