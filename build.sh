#!/bin/bash
set -e

APP_NAME="OfflineCatalogApp"
APP_DIR="./${APP_NAME}.app"
PAYLOAD_DIR="./Payload"
IPA_NAME="${APP_NAME}-v4.ipa"
ENTITLEMENTS="app.entitlements"

echo "Step 1: Clean up old artifacts"
rm -rf "$PAYLOAD_DIR" "$IPA_NAME"

if [ ! -d "$APP_DIR" ]; then
  echo "Error: $APP_DIR does not exist. Please add your built app here."
  exit 1
fi

echo "Step 2: Create Payload directory and copy .app"
mkdir -p "$PAYLOAD_DIR"
cp -r "$APP_DIR" "$PAYLOAD_DIR/"

echo "Step 3: Sign with ldid"
if ! command -v ldid &> /dev/null; then
  echo "Error: ldid not found in PATH"
  exit 1
fi

if [ -f "$ENTITLEMENTS" ]; then
  ldid -S"$ENTITLEMENTS" "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME"
else
  echo "Warning: no entitlements file, signing without entitlements"
  ldid "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME"
fi

echo "Step 4: Package Payload to IPA"
zip -r "$IPA_NAME" "$PAYLOAD_DIR"

echo "Step 5: Cleanup"
rm -rf "$PAYLOAD_DIR"

echo "Build complete: $IPA_NAME"
