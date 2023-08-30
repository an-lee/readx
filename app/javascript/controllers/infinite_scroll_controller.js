import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static targets = ["pending", "items", "scrollArea", "pagination", "loading"];

  paginationTargetConnected() {
    this.paginationTarget.classList.add("hidden");
  }

  loadingTargetConnected() {
    this.loadingTarget.classList.remove("hidden");
  }

  scrollAreaTargetConnected() {
    this.createObserver();
  }

  createObserver() {
    const observer = new IntersectionObserver(
      (entries) => this.handleIntersect(entries),
      {
        // https://github.com/w3c/IntersectionObserver/issues/124#issuecomment-476026505
        threshold: [0, 1.0],
      }
    );
    if (this.hasScrollAreaTarget) {
      observer.observe(this.scrollAreaTarget);
    }
  }

  handleIntersect(entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        this.loadBefore();
      }
    });
  }

  loadBefore() {
    if (!this.hasPaginationTarget) return;

    const next = this.paginationTarget;
    if (next && next.href) {
      get(next.href, {
        contentType: "application/json",
        responseKind: "turbo-stream",
      });
    }
  }

  pendingTargetConnected() {
    console.warn("Pending target connected");
    this.polling = setInterval(() => {
      this.loadAfter();
    }, 3000);
  }

  loadAfter() {
    const url = this.pendingTarget?.dataset?.url;
    console.log("url", url);
    if (!url) return;

    const id = (
      this.itemsTarget.children[4]?.id
    )?.split("_")[1];
    console.log("id", id);
    if (!id) return;

    get(`${url}?after=${id}`, {
      contentType: "application/json",
      responseKind: "turbo-stream",
    });
  }

  releasePending(event) {
    console.warn("Releasing pending target");
    this.itemsTarget.insertAdjacentHTML(
      "afterbegin",
      this.pendingTarget.innerHTML
    );
    this.pendingTarget.innerHTML = "";

    event.preventDefault();
    event.target.remove();
  }

  disconnect() {
    console.warn("Pending controller disconnected");
    clearInterval(this.polling);
  }
}
