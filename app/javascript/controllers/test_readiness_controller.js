import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.setAttribute("data-stimulus-ready", "true")
  }
}
