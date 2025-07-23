#!/bin/bash
set -e

APP_NAME="OfflineCatalogApp"
APP_APPDIR="./obj/iphoneos/${APP_NAME}.app"    # Theos default output path
PAYLOAD_DIR="./Payload"
IPA_NAME="${APP_NAME}.ipa"
ENTITLEMENTS="entitlements.plist"

echo "Step 1: Clean up old build artifacts"
rm -rf "$PAYLOAD_DIR" "$IPA_NAME"

echo "Step 2: Check if app directory exists"
if [ ! -d "$APP_APPDIR" ]; then
  echo "Error: $APP_APPDIR does not exist. Please build the app first."
  exit 1
fi

echo "Step 3: Create Payload directory and copy .app"
mkdir -p "$PAYLOAD_DIR"
cp -r "$APP_APPDIR" "$PAYLOAD_DIR/"

echo "Step 4: Check if app binary exists"
APP_BINARY="$PAYLOAD_DIR/${APP_NAME}.app/${APP_NAME}"
if [ ! -f "$APP_BINARY" ]; then
  echo "Error: App binary not found at $APP_BINARY"
  echo "Here is the content of the app directory:"
  ls -l "$PAYLOAD_DIR/${APP_NAME}.app"
  exit 1
fi

echo "Step 5: Sign the app binary with ldid"
if ! command -v ldid &> /dev/null; then
  echo "Error: ldid not found in PATH. Please install ldid."
  exit 1
fi
ldid -S"$ENTITLEMENTS" "$APP_BINARY"

echo "Step 6: Package Payload into .ipa file"
zip -r "$IPA_NAME" "$PAYLOAD_DIR"

echo "Step 7: Cleanup"
rm -rf "$PAYLOAD_DIR"

echo "Build complete! Generated $IPA_NAME"
