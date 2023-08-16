import { Application } from "@hotwired/stimulus"

import { appsignal } from "./appsignal";
import { installErrorHandler } from "@appsignal/stimulus";

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

installErrorHandler(appsignal, application);

export { application }
