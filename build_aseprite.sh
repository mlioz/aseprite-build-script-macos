#!/usr/bin/env zsh
set -euo pipefail

### ------------------------------
### Configuration
### ------------------------------

readonly ARCH="$(uname -m)"
readonly REPO_URL="https://github.com/aseprite/aseprite/releases/download/v1.3.16/Aseprite-v1.3.16.1-Source.zip"
readonly REPO_ZIP="Aseprite-v1.3.16.1-Source.zip"
readonly REPO_DIR="source"

readonly SKIA_URL="https://github.com/aseprite/skia/releases/download/m124-08a5439a6b/Skia-macOS-Release-$ARCH.zip"
readonly SKIA_DIR="Skia-macOS-Release-$ARCH"
readonly SKIA_ZIP="${SKIA_DIR}.zip"

readonly BUILD_DIR="build"
readonly APP_NAME="Aseprite.app"

readonly SDKROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

### ------------------------------
### Helper functions
### ------------------------------

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "Error: $1 is required"
    exit 1
  fi
}

log() {
  printf "%s\n" "$1"
}

case "$ARCH" in
  arm64)
    SKIA_ARCH="arm64"
    ;;
  x86_64)
    SKIA_ARCH="x64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

### ------------------------------
### Dependency checks
### ------------------------------

log "Checking for dependencies..."

for cmd in git curl unzip ninja cmake; do
  require_cmd "$cmd"
done

### ------------------------------
### Clone Aseprite (with submodules)
### ------------------------------

if [[ ! -d "$REPO_DIR/.git" ]]; then
  log "Downloading Aseprite repository..."
  curl -L --progress-bar -o "$REPO_ZIP" "$REPO_URL"

  mkdir -p "$REPO_DIR"
  unzip -q "$REPO_ZIP" -d "$REPO_DIR"
  rm -f "$REPO_ZIP"
else
  log "Aseprite repository already exists."
fi

### ------------------------------
### Download Skia binaries
### ------------------------------

if [[ ! -d "$SKIA_DIR" ]]; then
  log "Downloading Skia binaries..."
  curl -L --progress-bar -o "$SKIA_ZIP" "$SKIA_URL"

  mkdir -p "$SKIA_DIR"
  unzip -q "$SKIA_ZIP" -d "$SKIA_DIR"
  rm -f "$SKIA_ZIP"
else
  log "Skia binaries already exist."
fi

readonly SKIA_ROOT="$(pwd)/$SKIA_DIR"

### ------------------------------
### Configure & build
### ------------------------------

mkdir -p "$BUILD_DIR"

cmake --log-level=ERROR -S "$REPO_DIR" -B "$BUILD_DIR" \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_OSX_ARCHITECTURES=$ARCH \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
  -DCMAKE_OSX_SYSROOT="$SDKROOT" \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR="$SKIA_ROOT" \
  -DSKIA_LIBRARY_DIR=$SKIA_ROOT/out/Release-arm64 \
  -DSKIA_LIBRARY=$SKIA_ROOT/out/Release-arm64/libskia.a \
  -DPNG_ARM_NEON=on \
  -G Ninja

export NINJA_STATUS="[%f/%t] "
ninja -C "$BUILD_DIR" aseprite

### ------------------------------
### Collect result
### ------------------------------

log "Copying app bundle..."
cp -R "$BUILD_DIR/bin/$APP_NAME" .

### ------------------------------
### Cleanup
### ------------------------------

log "Cleaning up build artifacts..."
rm -rf "$BUILD_DIR" "$SKIA_DIR" "$REPO_DIR"

log "Done."
