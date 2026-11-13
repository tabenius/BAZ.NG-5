# NG-5 · RAGBAZ noise machine

A local-first, mobile-first noise generator styled after 1970s synths and the TR-909 era: a cobalt panel with orange keys.

- Five voices (white, pink, brown, blue, violet), each with level, tone (low-pass), pan and *breathe* (a slow amplitude swell)
- **Alter**: X-MOD (one voice ring-modulates another), SPACE (convolution with a decaying burst of a chosen noise), DRIFT (random-walk on levels and tone), dark/bright tilt, breaths per minute
- **Pulse**: binaural beat (headphones) and/or isochronic-style amplitude pulse; DESCENT steps α → δ, optionally skipping θ
- Sleep timer with an exponential fade; DUSK blackout screen; wake lock
- **BAKE TAPE**: renders a seamless 2-minute WAV loop that keeps playing with the screen locked
- Patches as JSON (copy and paste them to iterate with Claude)
- Data model: `fixed`, `params`, `meta` (drift, descent, breath), `settings`, `ui`, `themes`, `stats` → `inferred`, plus live-computed `derived`
- All state lives in `localStorage` (`ragbaz.ng5.v1`). Nothing leaves the device.

Install as a PWA by serving the folder over HTTPS (for example Cloudflare Pages). `sw.js` caches it for offline use.

Note: entrainment evidence is mixed. The masking noise and slow breathing are the sturdier parts.
