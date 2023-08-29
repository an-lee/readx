import { Controller } from "@hotwired/stimulus";
import { encode } from "js-base64";

export default class extends Controller {
  static values = {
    target: {
      type: String,
      default: "mixin",
    },
    text: String,
    title: String,
    url: String,
    appId: String,
    iconUrl: String,
  };

  connect() {
    const text =
      this.textValue ||
      document.querySelector('meta[name="description"]').content;
    const title = this.titleValue || document.title.split("|")[1];
    const url = this.urlValue || location.href;
    const icon = this.iconUrlValue || location.origin + "/logo.png";

    if (this.targetValue == "twitter") {
      this.element.href = `https://twitter.com/intent/tweet?text=${text}&url=${encodeURIComponent(
        url
      )}`;
    } else if (this.targetValue == "mixin") {
      const data = {
        action: url,
        app_id: this.appIdValue,
        title: title.substring(0, 36),
        description: text.substring(0, 128),
        icon_url: icon,
      };

      this.element.href = `mixin://send?category=app_card&data=${encodeURIComponent(
        encode(JSON.stringify(data))
      )}`;
    } else if (this.targetValue == "telegram") {
      this.element.href = `https://t.me/share/url?url=${encodeURIComponent(
        url
      )}&text=${encodeURIComponent(text)}`;
    }
  }
}
