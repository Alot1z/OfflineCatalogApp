#!/bin/bash
set -e

APP_NAME="OfflineCatalogApp"
APP_DIR="./build/Applications/${APP_NAME}.app"
PAYLOAD_DIR="./Payload"
IPA_NAME="${APP_NAME}.ipa"
ENTITLEMENTS="entitlements.plist"

echo "Step 1: Clean up old artifacts"
rm -rf "$PAYLOAD_DIR" "$IPA_NAME" build

echo "Step 2: Build the project with Theos"
make clean
make

if [ ! -d "$APP_DIR" ]; then
  echo "Error: App directory $APP_DIR not found after build."
  exit 1
fi

echo "Step 3: Create Payload directory and copy .app"
mkdir -p "$PAYLOAD_DIR"
cp -r "$APP_DIR" "$PAYLOAD_DIR/"

echo "Step 4: Sign the app with ldid"
if ! command -v ldid &> /dev/null; then
  echo "Error: ldid not found in PATH. Please install ldid."
  exit 1
fi

ldid -S"$ENTITLEMENTS" "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME"

echo "Step 5: Package Payload into .ipa file"
zip -r "$IPA_NAME" "$PAYLOAD_DIR"

echo "Step 6: Cleanup"
rm -rf "$PAYLOAD_DIR"

echo "Build complete! Generated $IPA_NAME"
