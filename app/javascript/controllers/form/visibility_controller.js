import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["switch", "element"]
  static values = {on: Array}

  connect() {
    this.#update()
  }

  toggle() {
    this.#withViewTransition(() => this.#update())
  }

  #update() {
    const elementType = this.switchTarget.type;

    let visible;
    switch (elementType) {
      case "checkbox":
        visible = this.switchTarget.checked;
        break;

      default:
        visible = this.onValue.includes(this.switchTarget.value);
    }

    this.elementTargets.forEach((element) => {
      element.style.display = visible ? "block" : "none"
    });
  }

  #withViewTransition(operation) {
    if (document.startViewTransition) {
      requestAnimationFrame(() => {
        document.startViewTransition(operation);
      });
    } else {
      operation();
    }
  }
}
