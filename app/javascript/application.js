// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

if (navigator.serviceWorker) {
  navigator.serviceWorker
    .register("/service-worker.js", { scope: "/" })
    .then(() => navigator.serviceWorker.ready)
    .then(() => console.log("PWA", "Service worker registered!"));
}
