import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["switch", "element"]
  static values = {on: Array}

  connect() {
    this.toggle()
  }

  toggle() {
    const elementType = this.switchTarget.type;

    let visible;
    switch (elementType) {
      case "checkbox":
        visible = this.switchTarget.checked;
        break;

      default:
        visible = this.onValue.includes(this.switchTarget.value);
    }

    const update = () => {
      this.elementTargets.forEach((element) => element.style.display = visible ? "block" : "none");
    };

    // Fallback for browsers that don't support View Transitions
    if (!document.startViewTransition) {
      update();
      return;
    }

    document.startViewTransition(() => update());
  }
}
