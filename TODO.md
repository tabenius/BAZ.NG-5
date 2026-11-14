# NG-5 · TODO

## P0: nightly use, done 2026-11-13
- [x] GitHub Pages-ready (`.nojekyll`); service worker: network-first page so updates arrive, cache-first assets, fonts cached for offline use, "new version, reload" banner
- [x] Durable storage: `navigator.storage.persist()` on first play, versioned schema with migrations, SAVE BACKUP (.json download) and RESTORE (file)
- [x] Patch links `#p=<base64url JSON>`: Claude sends a link, a banner offers LOAD/IGNORE, and the hash is cleared after reading. COPY LINK makes one from the current sound
- [x] Audio robustness: resume after system interruptions (statechange and visibility), RESUME banner, Media Session lock-screen play/pause/stop
- [x] Night log: one entry per session (preset, minutes, final Hz) with a quick rating (slept/drifty/woke/nope); the last 5 nights go into COPY PATCH
- [x] Sleep-timer chips in a 6-column grid

## iPhone / iPad pass, done 2026-11-14
- [x] `navigator.audioSession.type = "playback"` so the ring/silent switch doesn't mute live mode; silent `<audio>` fallback for older iOS
- [x] Tape fade on iOS (`audio.volume` is ignored there): stepped, pre-scaled copies of the loop, swapped near-gaplessly between two `<audio>` elements at loop ends, driven by `timeupdate`/`ended` so it works with the screen locked
- [x] Fixed: the tape loop crossfade was on the wrong end, which made a click at every 2-minute wrap
- [x] Touch: double-tap reset through pointer events (dblclick is unreliable on touch), drag up or right, 16px inputs so iOS never zooms, no callout or overscroll
- [x] Tablet: two-column layout from 980px, bigger knobs from 760px, three-column presets; keyboard shortcuts (space, D, B)
- [x] 180px apple-touch-icon, app title, `webkitOfflineAudioContext` fallback, one-time iOS hint pointing to BAKE TAPE

## Colours, done 2026-11-14
- [x] Nine themes on a ◐ COLOURS slider with swatches at the top: Cobalt, Paper (light), Moss, Amber terminal, Night, Red night, plus three clear themes
- [x] Clear · red–green safe (protan/deutan, Okabe–Ito voices), Clear · blue–yellow safe (tritan), Clear · black & white (achromatopsia/low vision)
- [x] Colour is never the only cue in clear themes: ringed bright LEDs, hollow unlit ones, outlined active keys (inverted keys in black & white)
- [x] All panel colours are CSS variables; checked with a Machado-2009 CVD simulation and WCAG contrast (clear themes ≥ 4.5:1)

## P1: next
- [ ] Verify on real devices: live mode with the screen locked under `audioSession=playback` (iOS 17+); timeupdate cadence while locked
- [ ] Encrypted sync (passphrase → key on device; ciphertext to a private repo or R2). Nothing readable leaves the device
- [ ] Sensing stage 1: mic permission, `enumerateDevices` and `devicechange` (external mic detection), room noise floor → adaptive masking level. Features only, never raw audio
- [ ] Breath-rate estimate from the mic → breath pacer follows, then leads, slower
- [ ] Event log: snore / rustle / wake, attached to the night log

## P2: horizon
- [ ] Multiple microphones with roles (body/room), clock alignment
- [ ] ESP32-S3 + I2S MEMS mic bedside node; on-chip feature extraction; WebSocket/MQTT to the PWA
- [ ] BLE heart-rate/HRV strap via Web Bluetooth; accelerometer
- [ ] EEG headband (OpenBCI/Muse): measure δ/θ/α/β and close the loop
- [ ] Product questions (later, not now)
