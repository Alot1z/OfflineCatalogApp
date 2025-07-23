#!/bin/bash
set -e

# Konstanter - tilpas efter dit setup
APP_NAME="OfflineCatalogApp"
APP_DIR="./${APP_NAME}.app"
PAYLOAD_DIR="./Payload"
IPA_NAME="${APP_NAME}.ipa"
ENTITLEMENTS="app.entitlements"  # Din entitlements-fil

echo "Step 1: Clean up old build artifacts"
rm -rf "$PAYLOAD_DIR" "$IPA_NAME"

echo "Step 2: Create Payload directory and copy .app"
mkdir -p "$PAYLOAD_DIR"
cp -r "$APP_DIR" "$PAYLOAD_DIR/"

echo "Step 3: Sign the app with ldid"
if ! command -v ldid &> /dev/null; then
    echo "Error: ldid is not installed or not in PATH"
    exit 1
fi

ldid -S"$ENTITLEMENTS" "$PAYLOAD_DIR/$APP_NAME.app/$APP_NAME"

echo "Step 4: Package Payload into .ipa file"
zip -r "$IPA_NAME" "$PAYLOAD_DIR"

echo "Step 5: Cleanup"
rm -rf "$PAYLOAD_DIR"

echo "Build complete! Generated $IPA_NAME"
