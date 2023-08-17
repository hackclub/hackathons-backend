import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "element"]

  connect() {
    this.toggle()
  }

  toggle() {
    let visible = this.checkboxTarget.checked;
    this.elementTargets.forEach((element) => element.style.display = visible ? "block" : "none");
  }
}
