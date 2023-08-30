import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    console.warn("Markets controller connected");
    this.polling = setInterval(() => {
      get("/markets", {
        responseKind: "turbo-stream",
      });
    }, 10000);
  }

  disconnect() {
    console.warn("Markets controller disconnected");
    clearInterval(this.polling);
  }
}
