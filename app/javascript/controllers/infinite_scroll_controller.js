import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static targets = [
    "noticeBox",
    "pending",
    "items",
    "scrollArea",
    "pagination",
    "loading",
  ];

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
    this.pendingTarget.addEventListener("DOMNodeInserted", () => {
      const count = this.pendingTarget.children.length;
      if (count > 0) {
        this.noticeBoxTarget.querySelector(
          "span.topics-pending-count"
        ).innerText = count;
        document.title = `(${count}) ${document.title}`;
        this.noticeBoxTarget.classList.remove("hidden");
      } else {
        this.noticeBoxTarget.classList.add("hidden");
      }
    });

    console.warn("Pending target connected");
    this.polling = setInterval(() => {
      this.loadAfter();
    }, 1000 * 60);
  }

  loadAfter() {
    const url = this.pendingTarget?.dataset?.url;
    if (!url) return;

    const id = (
      this.pendingTarget?.children[0]?.id || this.itemsTarget.children[0]?.id
    )?.split("_")[1];
    if (!id) return;

    const uri = new URL(location.origin + url);
    uri.searchParams.append("after", id);
    get(uri.toString(), {
      contentType: "application/json",
      responseKind: "turbo-stream",
    });
  }

  releasePending() {
    this.noticeBoxTarget.classList.add("hidden");
    document.title = document.title.replace(/^\(\d+\) /, "");
    this.itemsTarget.insertAdjacentHTML(
      "afterbegin",
      this.pendingTarget.innerHTML
    );
    this.pendingTarget.innerHTML = "";
  }

  disconnect() {
    console.warn("Pending controller disconnected");
    clearInterval(this.polling);
  }
}
