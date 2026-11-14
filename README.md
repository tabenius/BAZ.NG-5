# NG-5 · RAGBAZ noise machine

Model **MÍMISBRUNR**, after Mímir's well beneath the world tree.

A local-first, mobile-first noise generator styled after 1970s synths and the TR-909 era: a cobalt panel with orange keys.

- Five voices (white, pink, brown, blue, violet), each with level, tone (low-pass), pan and *breathe* (a slow amplitude swell)
- **Alter**: X-MOD (one voice ring-modulates another), SPACE (convolution with a decaying burst of a chosen noise), DRIFT (random-walk on levels and tone), dark/bright tilt, breaths per minute
- **Pulse**: binaural beat (headphones) and/or isochronic-style amplitude pulse; DESCENT steps α → δ, optionally skipping θ
- Nine colour themes on a slider at the top, three of them for colour vision differences (red–green, blue–yellow, black & white)
- Sleep timer with an exponential fade; DUSK blackout screen; wake lock
- **BAKE TAPE**: renders a seamless 2-minute WAV loop that keeps playing with the screen locked
- Patches as JSON or as links (`#p=…`), plus a night log with quick ratings, to iterate with Claude
- Backup/restore to a file; persistent storage; offline via service worker
- Data model: `fixed`, `params`, `meta` (drift, descent, breath), `settings`, `ui`, `themes`, `stats` → `inferred`, plus live-computed `derived`
- All state lives in `localStorage` (`ragbaz.ng5.v1`). Nothing leaves the device.

Live at **https://tabenius.github.io/BAZ.NG-5/** once Pages is on (Settings → Pages → Deploy from branch `main`, `/ (root)`). Open it on the phone and choose *Add to Home Screen*.

Roadmap: see [TODO.md](TODO.md).

Note: entrainment evidence is mixed. The masking noise and slow breathing are the sturdier parts.
