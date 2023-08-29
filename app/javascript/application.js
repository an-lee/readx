// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

const showLoading = () => {
  const loadingTpl = document.getElementById("loading-template")?.innerHTML;
  if (!loadingTpl) return;
  document.getElementById("modal").innerHTML = loadingTpl;
};

const hideLoading = () => {
  document.querySelectorAll(".loading-modal").forEach((el) => el.remove());
};

if (navigator.serviceWorker) {
  navigator.serviceWorker
    .register("/service-worker.js", { scope: "/" })
    .then(() => navigator.serviceWorker.ready)
    .then(() => console.log("PWA", "Service worker registered!"));
}

document.addEventListener("turbo:click", () => {
  showLoading();
});
