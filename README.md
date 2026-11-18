# BAZ NG-5 · RAGBAZ noise generator

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

Live at **https://ragbaz.cc/synth/baz-ng-5-noise-generator** (also mirrored at https://tabenius.github.io/BAZ.NG-5/). Open it on the phone and choose *Add to Home Screen*.

Roadmap: see [TODO.md](TODO.md).

Note: entrainment evidence is mixed. The masking noise and slow breathing are the sturdier parts.

## Android app (Tauri 2)

`src-tauri/` wraps the same `index.html` as a Tauri 2 app, with no bundler: `tauri.conf.json` lists the page, manifest and icons as `frontendDist`, so the APK carries exactly the files GitHub Pages and ragbaz.cc serve. Under Tauri the page skips the service-worker registration (it checks `window.__TAURI_INTERNALS__`). The app has no commands, plugins or IPC capabilities.

Screen lock: on an Android 14 emulator, live Web Audio kept playing with the screen locked (60 s) and with the app sent to the background (45 s); the process stayed unfrozen. There is no foreground service yet, so Doze, OEM battery savers or memory pressure can still stop a long night's session. A `mediaPlayback` foreground service with a notification is the robust fix; the BAKE TAPE mode is the fallback until then.

Build (needs the Android SDK, NDK 27 and the `aarch64-linux-android` / `x86_64-linux-android` Rust targets):

```sh
npm install
export ANDROID_HOME=$HOME/Android/Sdk NDK_HOME=$ANDROID_HOME/ndk/27.0.12077973
npm run android:debug     # debug-signed APK, installable for testing
npm run android:release   # unsigned release APK
```

APKs land in `src-tauri/gen/android/app/build/outputs/apk/universal/{debug,release}/`. A release APK must be signed before anyone can install it:

```sh
scripts/sign-android-release.sh sign    # -> dist/baz-ng-5-<version>.apk + .sha256
```

It aligns and signs with the release key in `~/.config/ragbaz-signing/ng5-release.p12` (asking for its password; nothing is written to disk) and refuses any key whose certificate does not match `release/android-signing.json` (SHA-256 `ad922e99…36d4`). The key is never stored in this repository. Android refuses updates signed by another key, so keep an offline backup of the keystore.

Releasing: bump `version` in `src-tauri/tauri.conf.json`, `src-tauri/Cargo.toml`, `package.json` and `ragbaz.component.json` together, tag, build, sign, then publish the signed APK to the RAGBAZ F-Droid repository at https://ragbaz.cc/fdroid/repo with rebsync's `scripts/publish-repos.sh build --upload` (set `RBQ_EXTRA_APKS` to `dist/`; the listing lives in rebsync's `scripts/repos/fdroid-metadata/cc.ragbaz.ng5.yml`). Publication needs the F-Droid repo key and a go-ahead.
