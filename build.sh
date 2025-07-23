#!/bin/bash
APP="OfflineCatalogApp"
BUILD_DIR=build/Release-iphoneos

set -e
xcodebuild -scheme "$APP" -configuration Release -derivedDataPath build
ldid -Sentitlements.plist "$BUILD_DIR/${APP}.app"
mkdir -p Payload
cp -R "$BUILD_DIR/${APP}.app" Payload/
zip -r "${APP}.ipa" Payload
rm -rf Payload
echo "✅ Built ${APP}.ipa"
