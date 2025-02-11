window.Turbo.StreamActions.after_unless_duplicate = function () {
  if (!this.firstChild?.id || !document.getElementById(this.firstChild.id)) {
    const stream = this.cloneNode(true)
    stream.setAttribute("action", "after")
    this.after(stream)
  }
}
