#!/bin/bash
set -e

APP_NAME="OfflineCatalogApp"
SCHEME="$APP_NAME"
BUILD_DIR="./build"
APP_PATH="$BUILD_DIR/Build/Products/Release-iphoneos/${APP_NAME}.app"
PAYLOAD_DIR="./Payload"
IPA_NAME="${APP_NAME}.ipa"
ENTITLEMENTS="app.entitlements"

echo "Step 1: Clean up old build artifacts"
rm -rf "$PAYLOAD_DIR" "$IPA_NAME" "$BUILD_DIR"

echo "Step 2: Build app with xcodebuild"
xcodebuild \
  -project "${APP_NAME}.xcodeproj" \
  -scheme "$SCHEME" \
  -configuration Release \
  -derivedDataPath "$BUILD_DIR"

echo "Step 3: Check if app was built successfully"
if [ ! -d "$APP_PATH" ]; then
  echo "Error: Built app not found at $APP_PATH"
  exit 1
fi

echo "Step 4: Prepare Payload directory"
mkdir -p "$PAYLOAD_DIR"
cp -r "$APP_PATH" "$PAYLOAD_DIR/"

echo "Step 5: Sign the app with ldid"
if ! command -v ldid &> /dev/null; then
  echo "Error: ldid not found in PATH. Please install ldid."
  exit 1
fi

if [ ! -f "$ENTITLEMENTS" ]; then
  echo "Warning: Entitlements file '$ENTITLEMENTS' not found, signing without entitlements."
  ldid "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME"
else
  ldid -S"$ENTITLEMENTS" "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME"
fi

echo "Step 6: Package Payload into .ipa file"
zip -r "$IPA_NAME" "$PAYLOAD_DIR"

echo "Step 7: Cleanup"
rm -rf "$PAYLOAD_DIR"

echo "Build complete! Generated $IPA_NAME"
