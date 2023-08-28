import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { active: Boolean };
  static targets = ["title", "links", "summary"];

  activeValueChanged(value) {
    if (value === undefined) return;

    if (value) {
      this.active();
    } else {
      this.inactive();
    }
  }

  toggle() {
    this.activeValue = true;
  }

  active() {
    document
      .querySelectorAll('[data-card-active-value="true"]')
      .forEach((element) => {
        if (element === this.element) return;
        element.dataset.cardActiveValue = false;
      });

    this.element.classList.add(
      "active",
      "border",
      "sm:rounded-lg",
      "shadow-xl",
      "bg-white"
    );
    this.element.classList.remove("cursor-pointer");
    this.titleTarget.classList.add("text-primary");
    this.summaryTarget.classList.remove(
      "sm:line-clamp-3",
      "hidden",
      "opacity-70"
    );
    if (this.hasLinksTarget) {
      this.linksTarget.classList.remove("hidden");
    }
  }

  inactive() {
    this.element.classList.remove(
      "active",
      "border",
      "sm:rounded-lg",
      "shadow-xl",
      "bg-white"
    );
    this.titleTarget.classList.remove("text-primary");
    this.element.classList.add("cursor-pointer");
    this.summaryTarget.classList.add("sm:line-clamp-3", "hidden", "opacity-70");
    if (this.hasLinksTarget) {
      this.linksTarget.classList.add("hidden");
    }
  }
}
