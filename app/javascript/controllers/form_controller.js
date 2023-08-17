import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let inputs = this.enabledVisibleFields();
    if (inputs.length === 1 && inputs[0].type === "text") {
      this.focusAtEndOfText(inputs[0]);
    }
  }

  submitOnClickOutside(event) {
    let clickedOutside = true;
    for (let input of this.enabledVisibleFields()) {
      if (input.contains(event.target)) {
        clickedOutside = false;
        break;
      }
    }

    if (clickedOutside) {
      this.element.requestSubmit();
    }
  }

  submitOnEnter(event) {
    if (event.key === "enter") {
      event.preventDefault();
      this.element.requestSubmit();
    }
  }

  // private

  enabledVisibleFields() {
    return this.element.querySelectorAll(
      "input:enabled:not([type=hidden]), select:enabled:not([type=hidden])"
    );
  }

  focusAtEndOfText(input) {
    input.focus();
    input.setSelectionRange(input.value.length, input.value.length);
  }
}
