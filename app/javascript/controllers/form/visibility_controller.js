import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "element"]

    connect() {
        this.toggle()
    }

    toggle() {
        let visible = this.inputTarget.checked;
        this.elementTargets.forEach((element) => element.style.display = visible ? "block" : "none");
    }
}
