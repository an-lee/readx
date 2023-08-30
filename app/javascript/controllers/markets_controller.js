import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    this.polling = setInterval(() => {
      get("/markets", {
        responseKind: "turbo-stream",
      });
    }, 10000);
  }

  disconnect() {
    clearInterval(this.polling);
  }
}
