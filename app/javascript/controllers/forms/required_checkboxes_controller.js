import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    /* Prevent form submission unless required checkboxes are checked.

       This controller may require all or some depending on the `require` value.
       - `every`: All checkboxes must be checked
       - `some`: At least one checkbox must be checked

       USAGE:
       1. Add the `data-controller` attribute to the form and set the `require`
          value to either `every` or `some`.
       2. Place the `button` target on the submit button that should be disabled.
       3. And place the `input` target and `changed` action on every checkbox
          that should be checked.
     */
    static targets = ["button", "input"]
    static values = {require: String}

    connect() {
        this.changed()
    }

    changed() {
        const message = {
            every: "Please select all options",
            some: "Please select at least one option",
        }[this.requireValue]

        let metRequirements = this.inputTargets[this.requireValue]((input) => input.checked)

        this.buttonTarget.disabled = !metRequirements
        this.buttonTarget.title = metRequirements ? null : message
    }
}
