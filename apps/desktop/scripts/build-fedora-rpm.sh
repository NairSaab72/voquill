#!/usr/bin/env bash
# Builds an unsigned voquill-desktop RPM with the Vulkan GPU sidecar on Fedora.
# Run apps/desktop/scripts/setup-linux.sh first to install the build packages.
set -euo pipefail

VERSION="${1:?usage: build-fedora-rpm.sh <version, e.g. 0.0.653>}"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
desktop_dir="$repo_root/apps/desktop"
sidecar_manifest="$repo_root/packages/rust_transcription/Cargo.toml"

fail() {
  echo "[ERROR] $1" >&2
  exit 1
}

for tool in cargo pnpm jq glslc clang; do
  command -v "$tool" >/dev/null 2>&1 || fail "Missing prerequisite: $tool"
done

# whisper-rs-sys pins bindgen 0.71, which generates empty structs with newer
# libclang (seen with 23). Generate bindings with an older libclang instead.
if [[ -z "${LIBCLANG_PATH:-}" ]] && (( $(clang -dumpversion | cut -d. -f1) > 21 )); then
  for llvm_version in 21 20 19 18; do
    if [[ -d "/usr/lib64/llvm${llvm_version}/lib64" ]]; then
      export LIBCLANG_PATH="/usr/lib64/llvm${llvm_version}/lib64"
      break
    fi
  done
  [[ -n "${LIBCLANG_PATH:-}" ]] || fail "No libclang <= 21 found. Run: sudo dnf install clang21-libs"
fi

# Disables -march=native so the RPM runs on CPUs other than the build machine's.
export CMAKE_TOOLCHAIN_FILE="$repo_root/packages/rust_transcription/cmake/linux-ci-toolchain.cmake"
export TAURI_PLATFORM=linux VOQUILL_DESKTOP_PLATFORM=linux FLAVOR=prod VITE_FLAVOR=prod
export VOQUILL_REQUIRE_GPU_SIDECAR=true

set -a
# shellcheck disable=SC1091
source <(grep '^VOQUILL_GOOGLE_CLIENT_' "$desktop_dir/.env.prod")
set +a

# The updater artifacts need the upstream signing key, so they are disabled.
tauri_config="$(mktemp --suffix=.json)"
trap 'rm -f "$tauri_config"' EXIT
jq --arg version "$VERSION" \
  '.productName = "voquill-desktop" | .mainBinaryName = "voquill-desktop" | .version = $version | .bundle.createUpdaterArtifacts = false' \
  "$desktop_dir/src-tauri/tauri.prod.conf.json" > "$tauri_config"

cd "$repo_root"
# whisper-rs-sys's build script does not rerun when the variables above change.
cargo clean --manifest-path "$sidecar_manifest" --release -p whisper-rs-sys
pnpm install --frozen-lockfile
pnpm exec turbo run build --filter=desktop...
pnpm --filter desktop run tauri build --bundles rpm --config "$tauri_config"

echo "[INFO] RPM written to $desktop_dir/src-tauri/target/release/bundle/rpm/"
