#!/bin/bash
set -e

APP_NAME="OfflineCatalogApp"
BUILD_DIR="./build/Build/Products/Release-iphoneos"
APP_DIR="${BUILD_DIR}/${APP_NAME}.app"
PAYLOAD_DIR="./Payload"
IPA_NAME="${APP_NAME}-v4.ipa"
ENTITLEMENTS="app.entitlements"
APP_BINARY="${APP_DIR}/${APP_NAME}"

echo "Step 1: Clean up old artifacts"
rm -rf "$PAYLOAD_DIR" "$IPA_NAME"

echo "Step 2: Check if app directory exists"
if [ ! -d "$APP_DIR" ]; then
  echo "Error: App directory '$APP_DIR' not found. Build the app first."
  exit 1
fi

echo "Step 3: Check if app binary exists"
if [ ! -f "$APP_BINARY" ]; then
  echo "Error: App binary '$APP_BINARY' not found."
  echo "Listing contents of app directory:"
  ls -l "$APP_DIR"
  exit 1
fi

echo "Step 4: Create Payload and copy .app"
mkdir -p "$PAYLOAD_DIR"
cp -r "$APP_DIR" "$PAYLOAD_DIR/"

echo "Step 5: Check if ldid is installed"
if ! command -v ldid &> /dev/null; then
  echo "Error: ldid not found. Please install ldid."
  exit 1
fi

echo "Step 6: Sign app binary with ldid and entitlements"
ldid -S"$ENTITLEMENTS" "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME"

echo "Step 7: Package Payload into IPA"
zip -r "$IPA_NAME" "$PAYLOAD_DIR"

echo "Step 8: Clean up Payload"
rm -rf "$PAYLOAD_DIR"

echo "Build complete! IPA generated: $IPA_NAME"
