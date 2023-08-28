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
      "bg-white",
      "space-y-6"
    );
    this.element.classList.remove("cursor-pointer", "space-y-4");
    this.titleTarget.classList.add("text-primary");
    this.summaryTarget.classList.remove(
      "sm:line-clamp-3",
      "hidden",
      "opacity-70"
    );

    this.element.scrollIntoView({ behavior: "smooth", block: "center" });

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
      "bg-white",
      "space-y-6"
    );
    this.element.classList.add("cursor-pointer", "space-y-4");
    this.titleTarget.classList.remove("text-primary");
    this.summaryTarget.classList.add("sm:line-clamp-3", "hidden", "opacity-70");
    if (this.hasLinksTarget) {
      this.linksTarget.classList.add("hidden");
    }
  }
}
