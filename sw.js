// BAZ NG-5 service worker: network-first for the page (so updates arrive), cache-first for static assets.
// PAGE: the page's own path, passed by the page when it registers (./ on GitHub Pages)
const PAGE=new URL(location.href).searchParams.get('page')||'./';
const C='ng5-v9', FILES=[PAGE,'manifest.webmanifest','icon-180.png','icon-192.png','icon-512.png'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(C).then(c=>c.addAll(FILES)));self.skipWaiting();});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==C).map(x=>caches.delete(x)))).then(()=>self.clients.claim()));});
self.addEventListener('fetch',e=>{
  const r=e.request; if(r.method!=='GET') return;
  const url=new URL(r.url);
  if(url.origin!==location.origin){
    if(!/fonts\.(googleapis|gstatic)\.com$/.test(url.hostname)) return;   // only fonts are cached cross-origin
    e.respondWith(caches.match(r).then(hit=>hit||fetch(r).then(res=>{const cp=res.clone();caches.open(C).then(c=>c.put(r,cp));return res;})));
    return;
  }
  if(r.mode==='navigate'){
    if(url.pathname!==new URL(PAGE,location.href).pathname) return;   // other pages sharing this scope are not ours
    e.respondWith(fetch(r).then(res=>{const cp=res.clone();caches.open(C).then(c=>c.put(PAGE,cp));return res;})
      .catch(()=>caches.match(PAGE)));
    return;
  }
  if(!r.url.startsWith(self.registration.scope)) return;   // host pages may add their own scripts and APIs; leave those to the network
  e.respondWith(caches.match(r).then(hit=>hit||fetch(r).then(res=>{const cp=res.clone();caches.open(C).then(c=>c.put(r,cp));return res;})));
});
