#!/bin/bash
set -e

APP_NAME="OfflineCatalogApp"
APP_DIR="./build/Build/Products/Release-iphoneos/${APP_NAME}.app"
PAYLOAD_DIR="./Payload"
IPA_NAME="${APP_NAME}-v4.ipa"
ENTITLEMENTS="app.entitlements"
APP_BINARY_PATH="$APP_DIR/$APP_NAME"

echo "Step 1: Clean up old artifacts"
rm -rf "$PAYLOAD_DIR" "$IPA_NAME"

if [ ! -d "$APP_DIR" ]; then
  echo "Error: App directory '$APP_DIR' does not exist. Build app first."
  exit 1
fi

echo "Step 2: Create Payload directory and copy .app"
mkdir -p "$PAYLOAD_DIR"
cp -r "$APP_DIR" "$PAYLOAD_DIR/"

if [ ! -f "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME" ]; then
  echo "Error: App binary not found at '$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME'"
  echo "Listing contents of app directory:"
  ls -l "$PAYLOAD_DIR/$APP_NAME.app"
  exit 1
fi

echo "Step 3: Sign app binary with ldid"
if ! command -v ldid &> /dev/null; then
  echo "Error: 'ldid' command not found. Please install ldid."
  exit 1
fi

if [ -f "$ENTITLEMENTS" ]; then
  ldid -S"$ENTITLEMENTS" "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME"
else
  echo "Warning: Entitlements file '$ENTITLEMENTS' not found, signing without entitlements."
  ldid "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME"
fi

echo "Step 4: Package Payload into IPA"
zip -r "$IPA_NAME" "$PAYLOAD_DIR"

echo "Step 5: Cleanup"
rm -rf "$PAYLOAD_DIR"

echo "Build complete: $IPA_NAME"
