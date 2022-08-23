'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba",
"main.dart.js": "60a3223c653d6e4e43610f414aa9e8bb",
"assets/AssetManifest.json": "378ecb4ec0027c994ee18c5b507c360b",
"assets/assets/fonts/Butcherman-Regular.ttf": "89df4409110e979e7afbe144f9783e36",
"assets/assets/images/wall.png": "48bb3c59e0ae2846a47dc6af35906396",
"assets/assets/images/RestartUp.png": "2ea5162cf7901103da6fe737b34970a8",
"assets/assets/images/playerCrashing1.png": "56405bcdc17a2fb2bd7de6d08d986a1b",
"assets/assets/images/playerMoving1.png": "157ae44afbf4319d8930ee9675aae7c2",
"assets/assets/images/RestartDown.png": "db0e9efc4e0f84fa4f82f4d624219dd4",
"assets/assets/images/enabled.png": "2ea5162cf7901103da6fe737b34970a8",
"assets/assets/images/playerMoving2.png": "0cad2a07303c90e5b251ef5da4729690",
"assets/assets/images/path.png": "8793d4f1b05000b5500191378b7094e6",
"assets/assets/images/playerIdle3.png": "60b21c42b3f2e7f77986dd195508c22c",
"assets/assets/images/restart.png": "51ee16a1803326f7f08c165951be8cee",
"assets/assets/images/goal.png": "cdf8853b471addbd3ea93d156f6b151d",
"assets/assets/images/playerIdle2.png": "9746aaa657b18dcf12628f9a0ad1ce6b",
"assets/assets/images/playerIdle1.png": "64c176b601c4504b0cc8f67ed7b09b84",
"assets/assets/images/disabled.png": "9104ea711eba7b90f51778bd145dfb4e",
"assets/assets/images/start.png": "1bc10b8be8271b0a93ac5d9fc8ca869f",
"assets/assets/audio/intro.wav": "89ae65eebd63f287f1c55e81dc255054",
"assets/assets/audio/theme-v3.wav": "a1ca7ed0fe3ffa703e3c1f8c9ee4b306",
"assets/assets/audio/loosing.wav": "66d65930aa26808d2bdf906a9a9d9227",
"assets/assets/audio/steps-2.wav": "1b9186d7006373eb495b5f0994fb0a8a",
"assets/assets/audio/bump-2.wav": "55c65c3476561f9133ba7aae8047b8ff",
"assets/assets/audio/bump.wav": "64758c21619ed7e182ad8ea69954f323",
"assets/assets/audio/far-apart.wav": "6cd9343f6ca94fc0f44f7cb4874ad0fe",
"assets/assets/audio/winning.wav": "f419fefb7930ef64115214dc94fa4cac",
"assets/FontManifest.json": "74aa3bee40747c420aa29dffce54833c",
"assets/NOTICES": "1aca7205fed9e1452b6672996e7c733b",
"flutter.js": "eb2682e33f25cd8f1fc59011497c35f8",
"index.html": "6d4285f66eac7290421aa22149435790",
"/": "6d4285f66eac7290421aa22149435790",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "4374eab8ef10d5aac0cc61bb10fca157",
"manifest.json": "f0f542fae16716d59b1cbaf5db338285",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
