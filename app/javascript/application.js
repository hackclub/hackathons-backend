// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "./custom_turbo_stream_actions.js"

import LocalTime from "local-time"
LocalTime.start()

document.addEventListener("turbo:morph", () => LocalTime.run())
