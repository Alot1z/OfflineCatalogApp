#!/bin/bash
set -e

APP_NAME="OfflineCatalogApp"
APP_APPDIR="./obj/iphoneos/${APP_NAME}.app"
PAYLOAD_DIR="./Payload"
IPA_NAME="${APP_NAME}.ipa"
ENTITLEMENTS="entitlements.plist"

echo "Cleaning old build artifacts..."
rm -rf "$PAYLOAD_DIR" "$IPA_NAME"

if [ ! -d "$APP_APPDIR" ]; then
  echo "Error: App directory $APP_APPDIR not found. Build failed?"
  exit 1
fi

echo "Copying app to Payload directory..."
mkdir -p "$PAYLOAD_DIR"
cp -r "$APP_APPDIR" "$PAYLOAD_DIR/"

APP_BINARY="$PAYLOAD_DIR/${APP_NAME}.app/${APP_NAME}"
if [ ! -f "$APP_BINARY" ]; then
  echo "Error: App binary $APP_BINARY not found!"
  ls -l "$PAYLOAD_DIR/${APP_NAME}.app"
  exit 1
fi

echo "Signing app binary with ldid..."
ldid -S"$ENTITLEMENTS" "$APP_BINARY"

echo "Packaging Payload into $IPA_NAME..."
zip -r "$IPA_NAME" "$PAYLOAD_DIR"

echo "Cleaning up..."
rm -rf "$PAYLOAD_DIR"

echo "Build completed: $IPA_NAME"
