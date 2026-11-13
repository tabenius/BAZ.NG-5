# NG-5 · TODO

## P0: nightly use, done 2026-11-13
- [x] GitHub Pages-ready (`.nojekyll`); service worker: network-first page so updates arrive, cache-first assets, fonts cached for offline use, "new version, reload" banner
- [x] Durable storage: `navigator.storage.persist()` on first play, versioned schema with migrations, SAVE BACKUP (.json download) and RESTORE (file)
- [x] Patch links `#p=<base64url JSON>`: Claude sends a link, a banner offers LOAD/IGNORE, and the hash is cleared after reading. COPY LINK makes one from the current sound
- [x] Audio robustness: resume after system interruptions (statechange and visibility), RESUME banner, Media Session lock-screen play/pause/stop
- [x] Night log: one entry per session (preset, minutes, final Hz) with a quick rating (slept/drifty/woke/nope); the last 5 nights go into COPY PATCH
- [x] Sleep-timer chips in a 6-column grid

## P1: next
- [ ] Tape-mode fade on iOS (iOS ignores `audio.volume`): bake a separate fade-out tape and switch to it at timer end
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
