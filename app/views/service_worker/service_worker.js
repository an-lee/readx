importScripts(
  "https://storage.googleapis.com/workbox-cdn/releases/7.0.0/workbox-sw.js"
);

const { CacheFirst, NetworkFirst } = workbox.strategies;
const { registerRoute } = workbox.routing;

// For every other page we use network first to ensure the most up-to-date resources
registerRoute(
  ({ request, url }) =>
    request.destination === "document" || request.destination === "",
  new NetworkFirst({
    cacheName: "documents",
  })
);

// For assets (scripts and images), we use cache first
registerRoute(
  ({ request }) =>
    request.destination === "script" || request.destination === "style",
  new CacheFirst({
    cacheName: "assets-styles-and-scripts",
  })
);
registerRoute(
  ({ request }) => request.destination === "image",
  new CacheFirst({
    cacheName: "assets-images",
  })
);
