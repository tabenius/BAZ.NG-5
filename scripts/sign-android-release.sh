#!/usr/bin/env bash
# Sign the BAZ NG-5 release APK with the app's release key.
#
#   scripts/sign-android-release.sh init     # once: create the release key
#   scripts/sign-android-release.sh sign     # zipalign + apksigner the unsigned release APK
#   scripts/sign-android-release.sh init-and-sign
#
# The key is box-local and never committed. Its certificate SHA-256 is pinned in
# release/android-signing.json; `sign` refuses a key that does not match it.
# Android refuses updates signed by any other key: back the keystore up offline.
#
# Environment (defaults in brackets):
#   NG5_KEYSTORE        [~/.config/ragbaz-signing/ng5-release.p12]
#   NG5_KEY_ALIAS       [ng5-release]
#   NG5_KEYSTORE_PASS   [prompted, not echoed, never written]
#   ANDROID_HOME        [~/Android/Sdk]
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
: "${NG5_KEYSTORE:=$HOME/.config/ragbaz-signing/ng5-release.p12}"
: "${NG5_KEY_ALIAS:=ng5-release}"
: "${ANDROID_HOME:=$HOME/Android/Sdk}"
bt=$(ls -d "$ANDROID_HOME"/build-tools/* | sort -V | tail -1)
apks="$root/src-tauri/gen/android/app/build/outputs/apk/universal/release"
unsigned="$apks/app-universal-release-unsigned.apk"
version=$(python3 -c "import json;print(json.load(open('$root/src-tauri/tauri.conf.json'))['version'])")
signed="$root/dist/baz-ng-5-$version.apk"
ok() { printf '  ✓ %s\n' "$*"; }
die() { printf '  ✗ %s\n' "$*" >&2; exit 1; }

ask_pass() {
  [ -n "${NG5_KEYSTORE_PASS:-}" ] && return
  read -rsp "$1: " NG5_KEYSTORE_PASS; echo
  if [ "${2:-}" = confirm ]; then
    local again; read -rsp "Repeat: " again; echo
    [ "$again" = "$NG5_KEYSTORE_PASS" ] || die "passwords differ"
    [ ${#NG5_KEYSTORE_PASS} -ge 12 ] || die "use at least 12 characters"
  fi
  export NG5_KEYSTORE_PASS
}

cert_sha256() { # of the keystore entry, lowercase hex without colons
  keytool -list -v -keystore "$NG5_KEYSTORE" -alias "$NG5_KEY_ALIAS" -storepass:env NG5_KEYSTORE_PASS \
    | sed -n 's/^\s*SHA256: //p' | tr -d ':' | tr 'A-F' 'a-f'
}

init() {
  [ ! -e "$NG5_KEYSTORE" ] || die "$NG5_KEYSTORE already exists; never replace a release key"
  mkdir -p "$(dirname "$NG5_KEYSTORE")"; chmod 700 "$(dirname "$NG5_KEYSTORE")"
  ask_pass "New BAZ NG-5 release keystore password" confirm
  keytool -genkeypair -keystore "$NG5_KEYSTORE" -storetype PKCS12 -alias "$NG5_KEY_ALIAS" \
    -keyalg RSA -keysize 4096 -validity 10000 -dname "CN=BAZ NG-5 release, O=RAGBAZ" \
    -storepass:env NG5_KEYSTORE_PASS -keypass:env NG5_KEYSTORE_PASS 2>/dev/null
  chmod 600 "$NG5_KEYSTORE"
  ok "created $NG5_KEYSTORE (back it up offline)"
  echo "  certificate sha256: $(cert_sha256)"
}

sign() {
  [ -f "$NG5_KEYSTORE" ] || die "no release key at $NG5_KEYSTORE (run: $0 init)"
  [ -f "$unsigned" ] || die "no $unsigned (run: npm run android:release)"
  [ ! -e "$signed" ] || die "$signed exists; move it away"
  ask_pass "BAZ NG-5 release keystore password"
  local have pinned
  have=$(cert_sha256) || true; [ -n "$have" ] || die "cannot read $NG5_KEY_ALIAS from $NG5_KEYSTORE (wrong password?)"
  if [ -f "$root/release/android-signing.json" ]; then
    pinned=$(python3 -c "import json;print(json.load(open('$root/release/android-signing.json'))['certificateSha256'])")
    [ "$have" = "$pinned" ] || die "key $have does not match pinned $pinned"
  fi
  mkdir -p "$root/dist"
  "$bt/zipalign" -P 16 -f 4 "$unsigned" "$signed.aligned"
  "$bt/apksigner" sign --ks "$NG5_KEYSTORE" --ks-key-alias "$NG5_KEY_ALIAS" \
    --ks-pass env:NG5_KEYSTORE_PASS --key-pass env:NG5_KEYSTORE_PASS --out "$signed" "$signed.aligned"
  rm -f "$signed.aligned" "$signed.idsig"
  "$bt/apksigner" verify --print-certs "$signed" | grep -i 'SHA-256' | sed 's/^/  /'
  (cd "$root/dist" && sha256sum "$(basename "$signed")" > "$(basename "$signed").sha256")
  ok "signed $signed"
}

case "${1:-}" in
  init) init ;;
  sign) sign ;;
  init-and-sign) init; sign ;;
  *) sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac
unset NG5_KEYSTORE_PASS
