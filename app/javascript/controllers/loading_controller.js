import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["cancelButton"];

  connect() {
    this.element.classList.add("modal-open");
    setTimeout(() => {
      this.cancelButtonTarget?.classList?.remove("hidden");
    }, 3 * 1000);
    this.timeout = setTimeout(() => {
      this.hide();
    }, 30 * 1000);
  }

  backdropClick(event) {
    if (event.target === event.currentTarget) {
      this.hide();
    }
  }

  hide() {
    this.element.classList.remove("modal-open");
    this.element.remove();
  }

  disconnect() {
    clearTimeout(this.timeout);
    this.hide();
  }
}
