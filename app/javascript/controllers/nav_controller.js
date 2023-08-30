import { Controller } from "@hotwired/stimulus";

const getMixinContext = () => {
  let ctx = {};
  if (
    window.webkit &&
    window.webkit.messageHandlers &&
    window.webkit.messageHandlers.MixinContext
  ) {
    ctx = JSON.parse(prompt("MixinContext.getContext()") || "");
    ctx.platform = ctx.platform || "iOS";
  } else if (
    window.MixinContext &&
    typeof window.MixinContext.getContext === "function"
  ) {
    ctx = JSON.parse(window.MixinContext.getContext());
    ctx.platform = ctx.platform || "Android";
  }
  ctx.appVersion = ctx.app_version;
  ctx.conversationId = ctx.conversation_id;
  return ctx;
};

export default class extends Controller {
  static targets = ["mixinShare", "genericShare"];
  connect() {
    const ctx = getMixinContext();
    if (ctx.app_version) {
      this.mixinShareTarget.classList.remove("hidden");
    } else if (navigator.share) {
      this.genericShareTarget.classList.remove("hidden");
    }
  }

  genericShare() {
    const text = document.querySelector('meta[name="description"]').content;
    const title = document.title;
    const url = location.href;

    navigator.share({
      title,
      text,
      url,
    });
  }
}
